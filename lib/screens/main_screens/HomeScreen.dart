import 'package:flutter/material.dart';
import 'package:pomodoro/screens/main_screens/StatisticsScreen.dart';
import 'package:pomodoro/screens/main_screens/TimerScreen.dart';
import 'package:pomodoro/screens/utility_screens/SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    TimerScreen(),
    const StatisticsScreen(),
  ];

  final List<String> _titles = [
    'Pomodoro',
    'Statistics',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Timer',
            activeIcon: Icon(Icons.timer_rounded),
            tooltip: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
            activeIcon: Icon(Icons.bar_chart_rounded),
            tooltip: 'Statistics',
          ),
        ],
      ),
    );
  }
}
