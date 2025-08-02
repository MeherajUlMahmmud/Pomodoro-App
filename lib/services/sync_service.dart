import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodoro/services/connectivity_service.dart';
import 'package:pomodoro/services/task_service.dart';
import 'package:pomodoro/services/session_service.dart';
import 'package:pomodoro/services/firebase_service.dart';
import 'package:pomodoro/models/task.dart';
import 'package:pomodoro/models/session.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final ConnectivityService _connectivityService = ConnectivityService();
  final TaskService _taskService = TaskService();
  final SessionService _sessionService = SessionService();
  final FirebaseService _firebaseService = FirebaseService();

  // Keys for storing sync data
  static const String _pendingTasksKey = 'pending_tasks_sync';
  static const String _pendingSessionsKey = 'pending_sessions_sync';
  static const String _lastSyncTimeKey = 'last_sync_time';
  static const String _syncQueueKey = 'sync_queue';

  // Add task to sync queue
  Future<void> addTaskToSyncQueue(Task task, String operation) async {
    final prefs = await SharedPreferences.getInstance();
    final syncQueue = await _getSyncQueue();

    syncQueue.add({
      'type': 'task',
      'operation': operation, // 'create', 'update', 'delete'
      'data': task.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    await prefs.setString(_syncQueueKey, jsonEncode(syncQueue));
  }

  // Add session to sync queue
  Future<void> addSessionToSyncQueue(
      PomodoroSession session, String operation) async {
    final prefs = await SharedPreferences.getInstance();
    final syncQueue = await _getSyncQueue();

    syncQueue.add({
      'type': 'session',
      'operation': operation, // 'create', 'update', 'delete'
      'data': session.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    await prefs.setString(_syncQueueKey, jsonEncode(syncQueue));
  }

  // Get sync queue
  Future<List<Map<String, dynamic>>> _getSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final syncQueueString = prefs.getString(_syncQueueKey);

    if (syncQueueString == null) return [];

    final List<dynamic> queue = jsonDecode(syncQueueString);
    return queue.cast<Map<String, dynamic>>();
  }

  // Clear sync queue
  Future<void> _clearSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_syncQueueKey);
  }

  // Process sync queue
  Future<void> processSyncQueue() async {
    if (!await _connectivityService.hasInternetConnection()) {
      return; // No internet, can't sync
    }

    final syncQueue = await _getSyncQueue();
    if (syncQueue.isEmpty) return;

    final List<Map<String, dynamic>> failedItems = [];

    for (final item in syncQueue) {
      try {
        final success = await _processSyncItem(item);
        if (!success) {
          failedItems.add(item);
        }
      } catch (e) {
        failedItems.add(item);
      }
    }

    // Update sync queue with failed items
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_syncQueueKey, jsonEncode(failedItems));

    // Update last sync time
    await _updateLastSyncTime();
  }

  // Process individual sync item
  Future<bool> _processSyncItem(Map<String, dynamic> item) async {
    try {
      final type = item['type'] as String;
      final operation = item['operation'] as String;
      final data = item['data'] as Map<String, dynamic>;

      if (type == 'task') {
        return await _syncTask(operation, data);
      } else if (type == 'session') {
        return await _syncSession(operation, data);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Sync task with Firebase
  Future<bool> _syncTask(
      String operation, Map<String, dynamic> taskData) async {
    try {
      final task = Task.fromJson(taskData);

      switch (operation) {
        case 'create':
          await _firebaseService.createTask(task);
          break;
        case 'update':
          await _firebaseService.updateTask(task);
          break;
        case 'delete':
          await _firebaseService.deleteTask(task.id);
          break;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Sync session with Firebase
  Future<bool> _syncSession(
      String operation, Map<String, dynamic> sessionData) async {
    try {
      final session = PomodoroSession.fromJson(sessionData);

      switch (operation) {
        case 'create':
          await _firebaseService.createSession(session);
          break;
        case 'update':
          await _firebaseService.updateSession(session);
          break;
        case 'delete':
          await _firebaseService.deleteSession(session.id);
          break;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Update last sync time
  Future<void> _updateLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncTimeKey, DateTime.now().toIso8601String());
  }

  // Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_lastSyncTimeKey);

    if (lastSyncString == null) return null;

    return DateTime.parse(lastSyncString);
  }

  // Check if sync is needed
  Future<bool> isSyncNeeded() async {
    final syncQueue = await _getSyncQueue();
    return syncQueue.isNotEmpty;
  }

  // Get sync queue size
  Future<int> getSyncQueueSize() async {
    final syncQueue = await _getSyncQueue();
    return syncQueue.length;
  }

  // Force sync (used when internet becomes available)
  Future<void> forceSync() async {
    if (await _connectivityService.hasInternetConnection()) {
      await processSyncQueue();
    }
  }

  // Sync all local data with Firebase
  Future<void> syncAllData() async {
    if (!await _connectivityService.hasInternetConnection()) {
      return;
    }

    try {
      // Sync tasks
      final tasks = await _taskService.getTasks();
      for (final task in tasks) {
        await addTaskToSyncQueue(task, 'create');
      }

      // Sync sessions
      final sessions = await _sessionService.getSessions();
      for (final session in sessions) {
        await addSessionToSyncQueue(session, 'create');
      }

      // Process the sync queue
      await processSyncQueue();
    } catch (e) {
      // Handle sync errors
    }
  }

  // Initialize sync service
  Future<void> initialize() async {
    // Initialize connectivity service
    await _connectivityService.initialize();

    // Listen for connectivity changes
    _connectivityService.connectivityStream.listen((status) {
      if (status == ConnectivityStatus.connected) {
        // Internet is available, try to sync
        forceSync();
      }
    });
  }
}
