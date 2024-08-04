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
                return AnimatedSwitcher(
                  duration: Duration(
                      milliseconds:
                          750), // Duración personalizada de la animación
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Switch(
                    key: ValueKey<bool>(notifier.themeMode == ThemeMode.dark),
                    value: notifier.themeMode == ThemeMode.dark,
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
