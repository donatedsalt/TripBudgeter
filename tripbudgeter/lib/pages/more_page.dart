import 'package:flutter/material.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';

class MorePageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MorePageAppBar({super.key});

  @override
  State<MorePageAppBar> createState() => _MorePageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MorePageAppBarState extends State<MorePageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('More', style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        // welcome user and more icon
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Text(
            "Welcome, ${supabase.auth.currentUser?.userMetadata?["username"]}!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // More options header and list of options
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Other Options",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text("Reports"),
              onTap: () {},
            ),
          ],
        ),
        // Settings header and list of settings
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("Language"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.currency_exchange),
              title: Text("Currency"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Help & Support"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text("Report a Bug"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                supabase.auth.signOut();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class MorePageFloatingActionButton extends StatelessWidget {
  const MorePageFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
