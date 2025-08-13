import 'package:flutter/material.dart';
import 'package:pomodoro/screens/auth_screens/LoginScreen.dart';
import 'package:pomodoro/screens/main_screens/HomeScreen.dart';
import 'package:pomodoro/screens/main_screens/TasksScreen.dart';
import 'package:pomodoro/screens/utility_screens/NotFoundScreen.dart';
import 'package:pomodoro/screens/utility_screens/SettingsScreen.dart';
import 'package:pomodoro/screens/utility_screens/SplashScreen.dart';
import 'package:pomodoro/screens/main_screens/StatisticsScreen.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/AccountPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/AboutUsPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/ContactUsPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/NotificationPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/PrivacyPolicyPage.dart';
import 'package:pomodoro/screens/utility_screens/settings_pages/TermsPage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case TasksScreen.routeName:
      return MaterialPageRoute(builder: (context) => const TasksScreen());
    case SettingsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
    case AccountPage.routeName:
      return MaterialPageRoute(builder: (context) => const AccountPage());
    case StatisticsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const StatisticsScreen());
    case NotificationPage.routeName:
      return MaterialPageRoute(builder: (context) => const NotificationPage());
    case PrivacyPolicyPage.routeName:
      return MaterialPageRoute(builder: (context) => const PrivacyPolicyPage());
    case TermsPage.routeName:
      return MaterialPageRoute(builder: (context) => const TermsPage());
    case AboutUsPage.routeName:
      return MaterialPageRoute(builder: (context) => const AboutUsPage());
    case ContactUsPage.routeName:
      return MaterialPageRoute(builder: (context) => const ContactUsPage());
    default:
      return MaterialPageRoute(builder: (context) => const NotFoundScreen());
  }
}
