import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart'; // Importar provider
import 'package:setup_app/auth/auth_gate.dart';
import 'package:setup_app/model/routine_model.dart';
import 'package:setup_app/tables/exercise.dart';
import 'auth/firebase_options.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

const clientId =
    '604232348381-vqjjs0pa8h0h0kh5hmomog78tv3s58a7.apps.googleusercontent.com';

List<Exercise> globalExercises = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'es']);
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

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => _themeNotifier,
        ),
        ChangeNotifierProvider<RoutineModel>(
          create: (_) => RoutineModel(),
        ),
      ],
      child: LocaleBuilder(
        builder: (locale) {
          return Consumer<ThemeNotifier>(
            builder: (context, theme, _) {
              return MaterialApp(
                title: 'Long Buttons App',
                localizationsDelegates: Locales.delegates,
                supportedLocales: Locales.supportedLocales,
                locale: locale,
                theme: FlexThemeData.light(
                    scheme: FlexScheme.deepBlue), //brandBlue
                darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepBlue),
                themeMode: theme.themeMode, // Usar el tema actual
                home: const AuthGate(),
              );
            },
          );
        },
      ),
    );
  }
}
