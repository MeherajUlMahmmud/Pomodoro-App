import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pomodoro/models/task.dart';
import 'package:pomodoro/models/session.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Authentication methods

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {
          'error': 'Google sign in was cancelled',
          'status': 400,
        };
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if user document exists, if not create it
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        return {
          'data': {
            'user': {
              'id': user.uid,
              'email': user.email,
              'displayName': user.displayName,
              'photoURL': user.photoURL,
            },
            'token': await user.getIdToken(),
          },
          'status': 200,
        };
      } else {
        return {
          'error': 'Google authentication failed',
          'status': 401,
        };
      }
    } catch (e) {
      return {
        'error': 'Something went wrong',
        'status': 500,
      };
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Task operations
  Future<void> createTask(Task task) async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(user.uid).collection('tasks').add({
      ...task.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(Task task) async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id)
        .update({
      ...task.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTask(String taskId) async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<List<Task>> getTasks() async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Task.fromJson(data);
    }).toList();
  }

  // Session operations
  Future<void> createSession(PomodoroSession session) async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .add({
      ...session.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSession(PomodoroSession session) async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .doc(session.id)
        .update({
      ...session.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteSession(String sessionId) async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .doc(sessionId)
        .delete();
  }

  Future<List<PomodoroSession>> getSessions() async {
    final user = getCurrentUser();
    if (user == null) throw Exception('User not authenticated');

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return PomodoroSession.fromJson(data);
    }).toList();
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = getCurrentUser();
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}
