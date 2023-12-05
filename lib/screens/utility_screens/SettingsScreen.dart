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
  handleLogout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          buildListTile(
            title: 'Account',
            icon: Icons.account_box_outlined,
            onTap: () {
              Navigator.pushNamed(context, AccountPage.routeName);
            },
          ),
          buildListTile(
            title: 'Timer',
            icon: Icons.timer_outlined,
            onTap: () {
              Navigator.pushNamed(context, TimerPage.routeName);
            },
          ),
          buildListTile(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            onTap: () {
              Navigator.pushNamed(context, NotificationPage.routeName);
            },
          ),
          buildListTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              Navigator.pushNamed(context, PrivacyPolicyPage.routeName);
            },
          ),
          buildListTile(
            title: 'Terms of Service',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              Navigator.pushNamed(context, TermsPage.routeName);
            },
          ),
          buildListTile(
            title: 'Logout',
            icon: Icons.exit_to_app,
            onTap: () {},
          ),
        ],
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
