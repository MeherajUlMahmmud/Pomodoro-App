import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pomodoro/firebase_options.dart';
import 'package:pomodoro/screens/utility_screens/SplashScreen.dart';
import 'package:pomodoro/utils/routes_handler.dart';
import 'package:pomodoro/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isNotEmpty) {
    await Firebase.apps.first.delete();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro',
      theme: createTheme(),
      onGenerateRoute: generateRoute,
      home: const SplashScreen(),
    );
  }
}
