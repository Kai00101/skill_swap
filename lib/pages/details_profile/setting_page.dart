import 'package:flutter/material.dart';

import '../../constr/notifier.dart';
import '../../main.dart';
import '../welcome_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              SkillSwap.of(context).toggleTheme();
            },
          )

        ],
      ),
      body:  Padding(
        padding: const EdgeInsets.only(top:30.0,left: 10),
        child: ListTile(
          title: const Text(
            'Logout',
            style: TextStyle(fontSize: 14, color: Colors.redAccent),
          ),
          leading: const Icon(Icons.logout, color: Colors.redAccent),
          onTap: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("Do you really want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Yes, Log Out",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );

            if (shouldLogout == true) {
              selectedPageNotifier.value = 0;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WelcomePage()),
              );
            }
          },
        ),
      ),
    );
  }
}
