import 'package:flutter/material.dart';
import 'package:pomodoro/services/firebase_service.dart';

class AccountPage extends StatefulWidget {
  static const routeName = '/account';

  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String displayPictureUrl = 'https://via.placeholder.com/150';
  String displayName = 'Display Name';
  String email = 'email@example.com';
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        setState(() {
          displayName = user.displayName ?? 'Display Name';
          email = user.email ?? 'email@example.com';
          displayPictureUrl =
              user.photoURL ?? 'https://via.placeholder.com/150';
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Account'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(displayPictureUrl),
            ),
            const SizedBox(height: 20),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
