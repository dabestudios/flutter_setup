import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:setup_app/auth/auth_gate.dart';
import 'auth/firebase_options.dart';

// TODO(codelab user): Get API key
const clientId =
    '604232348381-vqjjs0pa8h0h0kh5hmomog78tv3s58a7.apps.googleusercontent.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'dabestudios-set-up',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Long Buttons App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey[800],
          ),
        ),
      ),
      home: AuthGate(),
    );
  }
}
