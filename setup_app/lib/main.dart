import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup_app/auth/auth_gate.dart';
import 'package:setup_app/tables/exercise.dart';
import 'auth/firebase_options.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

const clientId =
    '604232348381-vqjjs0pa8h0h0kh5hmomog78tv3s58a7.apps.googleusercontent.com';

List<Exercise> globalExercises = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'dabestudios-set-up',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final ThemeNotifier _themeNotifier = ThemeNotifier();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => _themeNotifier,
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Long Buttons App',
            theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
            darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
            themeMode: theme.themeMode,
            home: AuthGate(),
          );
        },
      ),
    );
  }
}
