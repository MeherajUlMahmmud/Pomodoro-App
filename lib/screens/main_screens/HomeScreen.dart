import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:pomodoro/screens/utility_screens/SettingsScreen.dart';
import 'package:pomodoro/screens/main_screens/StatisticsScreen.dart';
import 'package:pomodoro/screens/main_screens/TasksScreen.dart';
import 'package:pomodoro/models/session.dart';
import 'package:pomodoro/services/session_service.dart';
import 'package:pomodoro/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/timer';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SessionService _sessionService = SessionService();
  final NotificationService _notificationService = NotificationService();
  final CountDownController _controller = CountDownController();

  // Timer state
  int _workDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;
  int _currentDuration = 25;
  int _completedWorkSessions = 0;
  int _completedBreakSessions = 0;

  // Session state
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  bool _isWorkSession = true;
  String? _currentSessionId;
  DateTime? _sessionStartTime;

  // Settings
  Map<String, dynamic> _settings = {};
  bool _autoStartBreaks = false;
  bool _autoStartWork = false;
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadTodayStats();
  }

  Future<void> _loadSettings() async {
    _settings = await _sessionService.getSettings();
    setState(() {
      _workDuration = _settings['workDuration'] ?? 25;
      _shortBreakDuration = _settings['shortBreakDuration'] ?? 5;
      _longBreakDuration = _settings['longBreakDuration'] ?? 15;
      _autoStartBreaks = _settings['autoStartBreaks'] ?? false;
      _autoStartWork = _settings['autoStartWork'] ?? false;
      _soundEnabled = _settings['soundEnabled'] ?? true;
      _notificationsEnabled = _settings['notificationsEnabled'] ?? true;
    });
  }

  Future<void> _loadTodayStats() async {
    final todaySessions =
        await _sessionService.getSessionsForDate(DateTime.now());
    final completedSessions =
        todaySessions.where((s) => s.isCompleted).toList();

    setState(() {
      _completedWorkSessions =
          completedSessions.where((s) => s.isWorkSession).length;
      _completedBreakSessions =
          completedSessions.where((s) => s.isBreakSession).length;
    });
  }

  void _startTimer(String sessionType, int duration) {
    final sessionId = _generateSessionId();
    final startTime = DateTime.now();

    setState(() {
      _currentDuration = duration;
      _isTimerRunning = true;
      _isTimerPaused = false;
      _isWorkSession = sessionType == 'work';
      _currentSessionId = sessionId;
      _sessionStartTime = startTime;
    });

    // Create and save session
    final session = PomodoroSession(
      id: sessionId,
      type: sessionType,
      duration: duration,
      startTime: startTime,
    );
    _sessionService.saveSession(session);

    _controller.restart(duration: duration * 60);

    if (_soundEnabled) {
      _notificationService.playHapticFeedback();
    }

    _notificationService.showSnackBar(
      context,
      _isWorkSession ? 'Work session started! 💪' : 'Break time! ☕',
    );
  }

  void _pauseTimer() {
    setState(() {
      _isTimerPaused = true;
    });
    _controller.pause();

    if (_soundEnabled) {
      _notificationService.playHapticFeedback();
    }
  }

  void _resumeTimer() {
    setState(() {
      _isTimerPaused = false;
    });
    _controller.resume();

    if (_soundEnabled) {
      _notificationService.playHapticFeedback();
    }
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
      _currentSessionId = null;
      _sessionStartTime = null;
    });
    _controller.reset();

    if (_soundEnabled) {
      _notificationService.playHapticFeedback();
    }
  }

  void _onComplete() async {
    if (_currentSessionId != null) {
      // Update session as completed
      final sessions = await _sessionService.getSessions();
      final session = sessions.firstWhere((s) => s.id == _currentSessionId);
      final updatedSession = session.copyWith(
        endTime: DateTime.now(),
        isCompleted: true,
      );
      await _sessionService.updateSession(updatedSession);
    }

    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
    });

    // Show completion notification
    if (_notificationsEnabled) {
      _notificationService.showTimerCompletionNotification(
        context,
        _isWorkSession
            ? 'work'
            : (_currentDuration == _longBreakDuration
                ? 'long_break'
                : 'short_break'),
      );
    }

    if (_soundEnabled) {
      _notificationService.playHapticFeedback();
    }

    // Update stats
    await _loadTodayStats();

    // Auto-start next session if enabled
    if (_isWorkSession && _autoStartBreaks) {
      _startNextBreak();
    } else if (!_isWorkSession && _autoStartWork) {
      _startNextWork();
    }
  }

  void _startNextBreak() {
    final shouldStartLongBreak = (_completedWorkSessions + 1) % 4 == 0;
    final breakType = shouldStartLongBreak ? 'long_break' : 'short_break';
    final breakDuration =
        shouldStartLongBreak ? _longBreakDuration : _shortBreakDuration;

    _startTimer(breakType, breakDuration);
  }

  void _startNextWork() {
    _startTimer('work', _workDuration);
  }

  String _generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Widget _buildTimerCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isWorkSession
                ? [const Color(0xFF527E5C), const Color(0xFF4CAF50)]
                : [const Color(0xFF2196F3), const Color(0xFF03A9F4)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              _isWorkSession ? 'Work Session' : 'Break Time',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              _isWorkSession ? Icons.work : Icons.free_breakfast,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            CircularCountDownTimer(
              duration: _currentDuration * 60,
              initialDuration: 0,
              controller: _controller,
              width: 200,
              height: 200,
              ringColor: Colors.white.withOpacity(0.3),
              fillColor: Colors.white,
              strokeWidth: 12.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textFormat: CountdownTextFormat.MM_SS,
              isReverse: true,
              isReverseAnimation: false,
              isTimerTextShown: true,
              autoStart: true,
              onStart: () {
                debugPrint('Timer Started');
              },
              onComplete: _onComplete,
              onChange: (String timeStamp) {
                debugPrint('Timer Changed: $timeStamp');
              },
            ),
            const SizedBox(height: 24),
            _buildTimerControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!_isTimerPaused)
          _buildControlButton(
            icon: Icons.pause,
            label: 'Pause',
            onTap: _pauseTimer,
          ),
        if (_isTimerPaused)
          _buildControlButton(
            icon: Icons.play_arrow,
            label: 'Resume',
            onTap: _resumeTimer,
          ),
        _buildControlButton(
          icon: Icons.replay,
          label: 'Reset',
          onTap: _resetTimer,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 32,
              color: _isWorkSession
                  ? const Color(0xFF527E5C)
                  : const Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionOptions() {
    return Column(
      children: [
        const Text(
          'Choose Your Session',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSessionCard(
                title: 'Work',
                duration: _workDuration,
                icon: Icons.work,
                color: const Color(0xFF527E5C),
                onTap: () => _startTimer('work', _workDuration),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSessionCard(
                title: 'Short Break',
                duration: _shortBreakDuration,
                icon: Icons.free_breakfast,
                color: const Color(0xFF2196F3),
                onTap: () => _startTimer('short_break', _shortBreakDuration),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSessionCard(
                title: 'Long Break',
                duration: _longBreakDuration,
                icon: Icons.weekend,
                color: const Color(0xFFFF9800),
                onTap: () => _startTimer('long_break', _longBreakDuration),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionCard({
    required String title,
    required int duration,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '$duration min',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayStats() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.work,
                    label: 'Work Sessions',
                    value: _completedWorkSessions.toString(),
                    color: const Color(0xFF527E5C),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.free_breakfast,
                    label: 'Break Sessions',
                    value: _completedBreakSessions.toString(),
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TasksScreen.routeName);
            },
            icon: const Icon(Icons.task_alt),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, StatisticsScreen.routeName);
            },
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isTimerRunning) ...[
              _buildTimerCard(),
            ] else ...[
              const SizedBox(height: 32),
              _buildSessionOptions(),
              const SizedBox(height: 32),
              _buildTodayStats(),
            ],
          ],
        ),
      ),
    );
  }
}
