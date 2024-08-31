import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup_app/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) {
                // Determinar si el sistema está en modo oscuro
                bool isSystemDarkMode =
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark;
                // Ajustar el switch según la preferencia del usuario o el modo del sistema
                bool isDarkMode = notifier.themeMode == ThemeMode.system
                    ? isSystemDarkMode
                    : notifier.themeMode == ThemeMode.dark;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 750),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Switch(
                    key: ValueKey<bool>(isDarkMode),
                    value: isDarkMode,
                    onChanged: (value) {
                      notifier.toggleTheme(value);
                    },
                  ),
                );
              },
            ),
          ),
          ListTile(
            title: const Text('Option 1'),
            subtitle: const Text('Description for option 1'),
            onTap: () {
              // Funcionalidad futura
            },
          ),
          ListTile(
            title: const Text('Option 2'),
            subtitle: const Text('Description for option 2'),
            onTap: () {
              // Funcionalidad futura
            },
          ),
          // Añadir más opciones según sea necesario
        ],
      ),
    );
  }
}
