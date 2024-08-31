import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            accountName: Text(user?.displayName ?? 'No Name'),
            accountEmail: Text(user?.email ?? 'No Email'),
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
            title: const Text('Profile'),
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
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph),
            title: const Text('Statistics'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Close'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
