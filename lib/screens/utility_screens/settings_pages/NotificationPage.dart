import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = '/notification';

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isEnabled = true;
  bool isSoundEnabled = true;
  bool isVibrationEnabled = true;
  bool isInAppNotificationEnabled = true;
  bool isWorkSessionNotificationEnabled = true;
  bool isShortBreakNotificationEnabled = true;
  bool isLongBreakNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Notification'),
      ),
      body: ListView(
        children: [
          buildSwitchListTile(
            'Enabled',
            isEnabled,
            Icons.notifications_active,
            (value) {
              setState(() {
                isEnabled = value;
              });
            },
          ),
          buildSwitchListTile(
            'Sound Enabled',
            isSoundEnabled,
            Icons.volume_up_outlined,
            (value) {
              setState(() {
                isSoundEnabled = value;
              });
            },
          ),
          buildSwitchListTile(
            'Vibration Enabled',
            isVibrationEnabled,
            Icons.vibration_outlined,
            (value) {
              setState(() {
                isVibrationEnabled = value;
              });
            },
          ),
          buildSwitchListTile(
            'In-App Notification Enabled',
            isInAppNotificationEnabled,
            Icons.notifications_outlined,
            (value) {
              setState(() {
                isInAppNotificationEnabled = value;
              });
            },
          ),
          buildSwitchListTile(
            'Work Session Notification Enabled',
            isWorkSessionNotificationEnabled,
            Icons.work_outline,
            (value) {
              setState(() {
                isWorkSessionNotificationEnabled = value;
              });
            },
          ),
          buildSwitchListTile(
            'Short Break Notification Enabled',
            isShortBreakNotificationEnabled,
            Icons.short_text_outlined,
            (value) {
              setState(() {
                isShortBreakNotificationEnabled = value;
              });
            },
          ),
          buildSwitchListTile(
            'Long Break Notification Enabled',
            isLongBreakNotificationEnabled,
            Icons.coffee_outlined,
            (value) {
              setState(() {
                isLongBreakNotificationEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  SwitchListTile buildSwitchListTile(
    String title,
    bool value,
    IconData icon,
    void Function(bool)? onChanged,
  ) {
    return SwitchListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
