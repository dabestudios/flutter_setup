import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_locales/flutter_locales.dart'; // Importa flutter_locales

class YourProfileScreen extends StatelessWidget {
  const YourProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(
            context, 'your_profile')), // Usa la clave de traducción
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Locales.string(
                  context, 'user_profile'), // Usa la clave de traducción
              style: const TextStyle(fontSize: 24),
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
              child: Text(Locales.string(
                  context, 'logout')), // Usa la clave de traducción
            ),
          ],
        ),
      ),
    );
  }
}
