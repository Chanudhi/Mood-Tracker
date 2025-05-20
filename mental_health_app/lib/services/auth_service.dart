import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/mood_tracker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Handle authentication state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print("Anonymous sign-in error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Auth state handler
  Widget handleAuthState() {
    return StreamBuilder<User?>(
      stream: authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MoodTrackerScreen(); // Replace with your home screen
        }
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: signInAnonymously,
              child: Text("Sign In Anonymously"),
            ),
          ),
        );
      },
    );
  }
}