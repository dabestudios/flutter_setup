import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_locales/flutter_locales.dart'; // Asegúrate de tener este import
import 'package:setup_app/main.dart';
import 'package:setup_app/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: clientId),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: LocaleText(
                  'app_name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LocaleText(
                  action == AuthAction.signIn
                      ? 'welcome_sign_in'
                      : 'welcome_sign_up',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LocaleText(
                  'terms_and_conditions',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          );
        }

        return const HomePage();
      },
    );
  }
}
