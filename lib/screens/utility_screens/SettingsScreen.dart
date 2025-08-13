import 'package:flutter/material.dart';
import 'package:pomodoro/services/firebase_service.dart';
import 'package:pomodoro/screens/auth_screens/LoginScreen.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/AccountPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/NotificationPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/AboutUsPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/ContactUsPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/PrivacyPolicyPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/TermsPage.dart';
import 'package:pomodoro/utils/helper.dart';
import 'package:pomodoro/utils/local_storage.dart';
import 'package:pomodoro/widgets/sync_status_widget.dart';

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
    {
      'title': 'About Us',
      'icon': Icons.info_outline,
      'route': AboutUsPage.routeName
    },
    {
      'title': 'Contact Us',
      'icon': Icons.contact_support_outlined,
      'route': ContactUsPage.routeName
    },
  ];

  final FirebaseService _firebaseService = FirebaseService();
  final LocalStorage _localStorage = LocalStorage();

  Future<void> handleLogout() async {
    try {
      await _firebaseService.signOut();
      await _localStorage.clearData();
      
      Helper().showSnackBar(
        context,
        'Logged out successfully',
        Theme.of(context).primaryColor,
      );
      
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      Helper().showSnackBar(
        context,
        'Failed to logout',
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Sync Status Widget
          const SyncStatusWidget(),

          // Settings Tiles
          ...List.generate(tiles.length, (index) {
            final tile = tiles[index];
            return buildListTile(
              title: tile['title'] as String,
              icon: tile['icon'] as IconData,
              onTap: () {
                Navigator.of(context).pushNamed(tile['route'] as String);
              },
            );
          }),

          // Logout Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                size: 30,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: handleLogout,
            ),
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
