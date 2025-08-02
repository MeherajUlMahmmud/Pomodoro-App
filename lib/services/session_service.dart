import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodoro/models/session.dart';
import 'package:pomodoro/services/sync_service.dart';

class SessionService {
  static const String _sessionsKey = 'pomodoro_sessions';
  static const String _settingsKey = 'pomodoro_settings';
  final SyncService _syncService = SyncService();

  // Save a session
  Future<void> saveSession(PomodoroSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getSessions();
    sessions.add(session);

    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
    
    // Add to sync queue
    await _syncService.addSessionToSyncQueue(session, 'create');
  }

  // Get all sessions
  Future<List<PomodoroSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsString = prefs.getString(_sessionsKey);

    if (sessionsString == null) return [];

    final sessionsJson = jsonDecode(sessionsString) as List;
    return sessionsJson.map((json) => PomodoroSession.fromJson(json)).toList();
  }

  // Get sessions for a specific date
  Future<List<PomodoroSession>> getSessionsForDate(DateTime date) async {
    final sessions = await getSessions();
    return sessions.where((session) {
      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return sessionDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  // Get sessions for the last N days
  Future<List<PomodoroSession>> getSessionsForLastDays(int days) async {
    final sessions = await getSessions();
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    return sessions.where((session) {
      return session.startTime.isAfter(cutoffDate);
    }).toList();
  }

  // Update a session
  Future<void> updateSession(PomodoroSession updatedSession) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == updatedSession.id);

    if (index != -1) {
      sessions[index] = updatedSession;
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = sessions.map((s) => s.toJson()).toList();
      await prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
      
      // Add to sync queue
      await _syncService.addSessionToSyncQueue(updatedSession, 'update');
    }
  }

  // Delete a session
  Future<void> deleteSession(String sessionId) async {
    final sessions = await getSessions();
    final sessionToDelete = sessions.firstWhere((s) => s.id == sessionId);
    sessions.removeWhere((s) => s.id == sessionId);

    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
    
    // Add to sync queue
    await _syncService.addSessionToSyncQueue(sessionToDelete, 'delete');
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final sessions = await getSessions();
    final completedSessions = sessions.where((s) => s.isCompleted).toList();

    int totalWorkSessions = 0;
    int totalShortBreaks = 0;
    int totalLongBreaks = 0;
    int totalWorkMinutes = 0;
    int totalBreakMinutes = 0;

    for (final session in completedSessions) {
      if (session.type == 'work') {
        totalWorkSessions++;
        totalWorkMinutes += session.duration;
      } else if (session.type == 'short_break') {
        totalShortBreaks++;
        totalBreakMinutes += session.duration;
      } else if (session.type == 'long_break') {
        totalLongBreaks++;
        totalBreakMinutes += session.duration;
      }
    }

    return {
      'totalSessions': completedSessions.length,
      'workSessions': totalWorkSessions,
      'shortBreaks': totalShortBreaks,
      'longBreaks': totalLongBreaks,
      'workMinutes': totalWorkMinutes,
      'breakMinutes': totalBreakMinutes,
      'totalMinutes': totalWorkMinutes + totalBreakMinutes,
    };
  }

  // Get daily statistics for the last 7 days
  Future<List<Map<String, dynamic>>> getDailyStatistics() async {
    final List<Map<String, dynamic>> dailyStats = [];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final sessions = await getSessionsForDate(date);
      final completedSessions = sessions.where((s) => s.isCompleted).toList();

      int workMinutes = 0;
      int breakMinutes = 0;

      for (final session in completedSessions) {
        if (session.isWorkSession) {
          workMinutes += session.duration;
        } else {
          breakMinutes += session.duration;
        }
      }

      dailyStats.add({
        'date': date,
        'workMinutes': workMinutes,
        'breakMinutes': breakMinutes,
        'totalMinutes': workMinutes + breakMinutes,
        'sessions': completedSessions.length,
      });
    }

    return dailyStats;
  }

  // Save settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  // Get settings
  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(_settingsKey);

    if (settingsString == null) {
      // Default settings
      return {
        'workDuration': 25,
        'shortBreakDuration': 5,
        'longBreakDuration': 15,
        'longBreakInterval': 4,
        'autoStartBreaks': false,
        'autoStartWork': false,
        'soundEnabled': true,
        'notificationsEnabled': true,
      };
    }

    return jsonDecode(settingsString);
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionsKey);
    await prefs.remove(_settingsKey);
  }
}
