import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'package:setup_app/main.dart';



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'settings')),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(Locales.string(context, 'dark_mode')),
            trailing: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) {
                bool isSystemDarkMode =
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark;
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
            title: Text(Locales.string(context, 'language')),
            trailing: PopupMenuButton<String>(
              // bandera del idioma actual
              icon: const Icon(Icons.language),
              onSelected: (String newValue) {
                Locales.change(context, newValue);
              },

              itemBuilder: (BuildContext context) {
                return languages
                    .map<PopupMenuItem<String>>(
                      (String value) => PopupMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList();
              },
            ),
          ),
          ListTile(
            title: Text(Locales.string(context, 'option_1')),
            subtitle: Text(Locales.string(context, 'description_option_1')),
            onTap: () {
              // Funcionalidad futura
            },
          ),
          ListTile(
            title: Text(Locales.string(context, 'option_2')),
            subtitle: Text(Locales.string(context, 'description_option_2')),
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
