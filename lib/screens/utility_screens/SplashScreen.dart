import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/screens/auth_screens/LoginScreen.dart';
import 'package:pomodoro/screens/main_screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        });
      } else {
        print('User is signed in!');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Pomodoro",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
