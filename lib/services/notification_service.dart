import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Show a simple snackbar notification
  void showSnackBar(BuildContext context, String message,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Show a dialog notification
  Future<void> showCustomDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            if (cancelText != null)
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
              ),
            if (confirmText != null)
              TextButton(
                child: Text(confirmText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
          ],
        );
      },
    );
  }

  // Show timer completion notification
  void showTimerCompletionNotification(
      BuildContext context, String sessionType) {
    String title = '';
    String message = '';

    switch (sessionType) {
      case 'work':
        title = 'Work Session Complete! 🎉';
        message = 'Great job! Time for a break.';
        break;
      case 'short_break':
        title = 'Short Break Complete! ☕';
        message = 'Ready to get back to work?';
        break;
      case 'long_break':
        title = 'Long Break Complete! 🌟';
        message = 'You\'ve earned this rest. Ready for the next session?';
        break;
    }

    showCustomDialog(
      context: context,
      title: title,
      message: message,
      confirmText: 'Continue',
      cancelText: 'Close',
    );
  }

  // Play haptic feedback
  void playHapticFeedback() {
    HapticFeedback.vibrate();
  }

  // Show session summary
  void showSessionSummary(
    BuildContext context, {
    required int workSessions,
    required int totalWorkMinutes,
    required int totalBreakMinutes,
  }) {
    showCustomDialog(
      context: context,
      title: 'Session Summary 📊',
      message: 'You completed $workSessions work sessions today!\n\n'
          'Total work time: ${totalWorkMinutes} minutes\n'
          'Total break time: ${totalBreakMinutes} minutes\n'
          'Total time: ${totalWorkMinutes + totalBreakMinutes} minutes',
      confirmText: 'Great!',
    );
  }

  // Show achievement notification
  void showAchievement(BuildContext context, String achievement) {
    showSnackBar(
      context,
      '🏆 Achievement Unlocked: $achievement',
      backgroundColor: Colors.amber,
    );
  }

  // Show streak notification
  void showStreakNotification(BuildContext context, int streak) {
    showSnackBar(
      context,
      '🔥 $streak day streak! Keep it up!',
      backgroundColor: Colors.orange,
    );
  }
}
