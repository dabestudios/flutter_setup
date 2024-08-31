import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart'; // Asegúrate de importar flutter_locales
import 'package:setup_app/pages/home_page.dart';
import 'package:setup_app/pages/settings_page.dart';
import 'package:setup_app/pages/statistics_page.dart';
import 'package:setup_app/pages/your_profile.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? ''),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: user?.photoURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(user!.photoURL!),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            decoration: BoxDecoration(color: Colors.blueGrey[800]),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(Locales.string(context, 'profile')), // Traducción
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const YourProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(Locales.string(context, 'home')), // Traducción
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph),
            title: Text(Locales.string(context, 'statistics')), // Traducción
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatisticsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(Locales.string(context, 'settings')), // Traducción
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(Locales.string(context, 'close')), // Traducción
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
