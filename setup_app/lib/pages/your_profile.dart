import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class YourProfileScreen extends StatelessWidget {
  const YourProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut(); // Sign out from Google account
                GoogleSignIn().disconnect(); // Disconnect from Google account
                FirebaseAuth.instance.signOut().then((_) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
