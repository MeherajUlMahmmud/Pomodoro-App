import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pomodoro/firebase_options.dart';
import 'package:pomodoro/screens/utility_screens/SplashScreen.dart';
import 'package:pomodoro/utils/routes_handler.dart';
import 'package:pomodoro/utils/theme.dart';
import 'package:pomodoro/services/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize sync service
  await SyncService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer',
      theme: createTheme(),
      onGenerateRoute: generateRoute,
      home: const SplashScreen(),
    );
  }
}
