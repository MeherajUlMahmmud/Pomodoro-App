import 'package:flutter/material.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/AccountPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/NotificationPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/PrivacyPolicyPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/TermsPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/TimerPage.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final tiles = [
    {
      'title': 'Account',
      'icon': Icons.account_box_outlined,
      'route': AccountPage.routeName
    },
    // {
    //   'title': 'View Statistics',
    //   'icon': Icons.bar_chart_outlined,
    //   'route': StatisticsScreen.routeName
    // },
    {
      'title': 'Timer',
      'icon': Icons.timer_outlined,
      'route': TimerPage.routeName
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications_outlined,
      'route': NotificationPage.routeName
    },
    {
      'title': 'Privacy Policy',
      'icon': Icons.privacy_tip_outlined,
      'route': PrivacyPolicyPage.routeName
    },
    {
      'title': 'Terms of Service',
      'icon': Icons.document_scanner_outlined,
      'route': TermsPage.routeName
    },
  ];

  handleLogout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          final tile = tiles[index];
          return buildListTile(
            title: tile['title'] as String,
            icon: tile['icon'] as IconData,
            onTap: () {
              Navigator.of(context).pushNamed(tile['route'] as String);
            },
          );
        },
      ),
    );
  }

  Widget buildListTile({
    required String title,
    required IconData icon,
    required Function onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
        title: Text(title),
        onTap: () => onTap(),
      ),
    );
  }
}
