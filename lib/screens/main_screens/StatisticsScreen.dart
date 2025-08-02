import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/services/session_service.dart';
import 'package:pomodoro/models/session.dart';

final _dateFormat = DateFormat('MMM dd');
final _monthFormat = DateFormat('MMM yyyy');

class StatisticsScreen extends StatefulWidget {
  static const routeName = '/statistics';
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final SessionService _sessionService = SessionService();

  Map<String, dynamic> _overallStats = {};
  List<Map<String, dynamic>> _dailyStats = [];
  List<PomodoroSession> _recentSessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final overallStats = await _sessionService.getStatistics();
      final dailyStats = await _sessionService.getDailyStatistics();
      final recentSessions = await _sessionService.getSessionsForLastDays(7);

      setState(() {
        _overallStats = overallStats;
        _dailyStats = dailyStats;
        _recentSessions = recentSessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverallStats(),
                    const SizedBox(height: 24),
                    _buildDailyChart(),
                    const SizedBox(height: 24),
                    _buildSessionTypeChart(),
                    const SizedBox(height: 24),
                    _buildRecentSessions(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverallStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.work,
                    title: 'Work Sessions',
                    value: _overallStats['workSessions']?.toString() ?? '0',
                    color: const Color(0xFF527E5C),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.free_breakfast,
                    title: 'Break Sessions',
                    value: (_overallStats['shortBreaks'] ??
                            0 + _overallStats['longBreaks'] ??
                            0)
                        .toString(),
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.timer,
                    title: 'Work Time',
                    value: '${_overallStats['workMinutes'] ?? 0}m',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.timer_off,
                    title: 'Break Time',
                    value: '${_overallStats['breakMinutes'] ?? 0}m',
                    color: const Color(0xFF03A9F4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChart() {
    if (_dailyStats.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('No data available for daily chart'),
          ),
        ),
      );
    }

    final chartData = _dailyStats.map((day) {
      return {
        'date': _dateFormat.format(day['date']),
        'workMinutes': day['workMinutes'],
        'breakMinutes': day['breakMinutes'],
      };
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last 7 Days Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Chart(
                data: chartData,
                variables: {
                  'date': Variable(
                    accessor: (Map map) => map['date'] as String,
                    scale: OrdinalScale(tickCount: 7),
                  ),
                  'workMinutes': Variable(
                    accessor: (Map map) => map['workMinutes'] as num,
                  ),
                  'breakMinutes': Variable(
                    accessor: (Map map) => map['breakMinutes'] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    position: Varset('date') * Varset('workMinutes'),
                    color: ColorEncode(value: const Color(0xFF527E5C)),
                  ),
                  IntervalMark(
                    position: Varset('date') * Varset('breakMinutes'),
                    color: ColorEncode(value: const Color(0xFF2196F3)),
                  ),
                ],
                axes: [
                  Defaults.horizontalAxis,
                  Defaults.verticalAxis,
                ],
                coord: RectCoord(),
                selections: {
                  'tooltip': PointSelection(
                    on: {GestureType.tapDown, GestureType.hover},
                    dim: Dim.x,
                  ),
                },
                tooltip: TooltipGuide(
                  selections: {'tooltip'},
                  followPointer: [false, true],
                  align: Alignment.topLeft,
                  offset: const Offset(-20, -20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTypeChart() {
    final workSessions = _overallStats['workSessions'] ?? 0;
    final shortBreaks = _overallStats['shortBreaks'] ?? 0;
    final longBreaks = _overallStats['longBreaks'] ?? 0;
    final total = workSessions + shortBreaks + longBreaks;

    if (total == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('No sessions completed yet'),
          ),
        ),
      );
    }

    final chartData = [
      {'type': 'Work', 'value': workSessions, 'color': const Color(0xFF527E5C)},
      {
        'type': 'Short Break',
        'value': shortBreaks,
        'color': const Color(0xFF2196F3)
      },
      {
        'type': 'Long Break',
        'value': longBreaks,
        'color': const Color(0xFFFF9800)
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Chart(
                data: chartData,
                variables: {
                  'type': Variable(
                    accessor: (Map map) => map['type'] as String,
                  ),
                  'value': Variable(
                    accessor: (Map map) => map['value'] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    position: Varset('value') / Varset('type'),
                    color: ColorEncode(
                      value: const Color(0xFF527E5C),
                    ),
                  ),
                ],
                coord: PolarCoord(),
                axes: [
                  Defaults.circularAxis,
                  Defaults.radialAxis,
                ],
                selections: {
                  'tooltip': PointSelection(
                    on: {GestureType.tapDown, GestureType.hover},
                    dim: Dim.x,
                  ),
                },
                tooltip: TooltipGuide(
                  selections: {'tooltip'},
                  followPointer: [false, true],
                  align: Alignment.topLeft,
                  offset: const Offset(-20, -20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessions() {
    if (_recentSessions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('No recent sessions'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Sessions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_recentSessions
                .take(10)
                .map((session) => _buildSessionTile(session))),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(PomodoroSession session) {
    final isWork = session.isWorkSession;
    final color = isWork ? const Color(0xFF527E5C) : const Color(0xFF2196F3);
    final icon = isWork ? Icons.work : Icons.free_breakfast;
    final status = session.isCompleted ? 'Completed' : 'Incomplete';
    final statusColor = session.isCompleted ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWork ? 'Work Session' : 'Break Session',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${session.duration} minutes • ${_dateFormat.format(session.startTime)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
