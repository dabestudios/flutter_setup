import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup_app/main.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dark Mode'),
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
                  duration: Duration(milliseconds: 750),
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
            title: Text('Option 1'),
            subtitle: Text('Description for option 1'),
            onTap: () {
              // Funcionalidad futura
            },
          ),
          ListTile(
            title: Text('Option 2'),
            subtitle: Text('Description for option 2'),
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
