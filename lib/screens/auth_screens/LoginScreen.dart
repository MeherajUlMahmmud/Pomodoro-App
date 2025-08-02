// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pomodoro/services/firebase_service.dart';
import 'package:pomodoro/screens/main_screens/HomeScreen.dart';
import 'package:pomodoro/utils/helper.dart';
import 'package:pomodoro/utils/local_storage.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalStorage localStorage = LocalStorage();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pomodoro',
                  style: TextStyle(
                    fontSize: 35,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 50),
                _buildGoogleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    signInWithGoogle() async {
      setState(() {
        isLoading = true;
      });

      try {
        final data = await FirebaseService().signInWithGoogle();

        if (data['status'] == 200) {
          await localStorage.writeData('user', data['data']['user']);
          await localStorage.writeStringData('token', data['data']['token']);

          Helper().showSnackBar(
            context,
            'Login Successful',
            Theme.of(context).primaryColor,
          );

          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else {
          Helper().showSnackBar(
            context,
            data['error'],
            Colors.red,
          );
        }
      } catch (e) {
        Helper().showSnackBar(
          context,
          'Something went wrong',
          Colors.red,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

    return GestureDetector(
      onTap: !isLoading ? signInWithGoogle : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: !isLoading
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.png',
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 10),
            Text(
              !isLoading ? 'Sign in with Google' : 'Signing in...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
