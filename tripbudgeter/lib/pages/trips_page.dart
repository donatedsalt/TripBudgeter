import 'package:flutter/material.dart';
import 'package:tripbudgeter/pages/add_trip_page.dart';

class TripsPageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TripsPageAppBar({super.key});

  @override
  State<TripsPageAppBar> createState() => _TripsPageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TripsPageAppBarState extends State<TripsPageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Trips', style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
    );
  }
}

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        // Current Trip
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Current Trip",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.flight_takeoff),
                title: Text("Paris"),
                subtitle: Text("\$1280.00 / \$2000.00"),
                trailing: Text("Jan 10"),
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        // Completed Trips list
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Completed Trips",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.flight_takeoff),
              title: Text("Taiwan"),
              subtitle: Text("\$1000.00"),
              trailing: Text("Nov 01"),
            ),
            ListTile(
              leading: Icon(Icons.flight_takeoff),
              title: Text("Korea"),
              subtitle: Text("\$2500.00"),
              trailing: Text("Mar 16"),
            ),
            ListTile(
              leading: Icon(Icons.flight_takeoff),
              title: Text("Japan"),
              subtitle: Text("\$4000.00"),
              trailing: Text("Oct 21"),
            ),
          ],
        ),
      ],
    );
  }
}

class TripsPageFloatingActionButton extends StatelessWidget {
  const TripsPageFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTripPage()),
        );
      },
      child: Icon(Icons.add),
    );
  }
}
