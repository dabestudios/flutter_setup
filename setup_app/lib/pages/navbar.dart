import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:setup_app/pages/new_page.dart';
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
            accountName: Text(user!.displayName!),
            accountEmail: user.email != null ? Text(user.email!) : Text('You'),
            currentAccountPicture: user.photoURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                  )
                : const CircleAvatar(
                    child: UserAvatar(size: 42.0),
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
                MaterialPageRoute(builder: (context) => const NewPage()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.auto_graph),
            title: Text('Statistics'),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewPage()),
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
