import 'package:flutter/material.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';

class HomePageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomePageAppBar({super.key});

  @override
  State<HomePageAppBar> createState() => _HomePageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomePageAppBarState extends State<HomePageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        // welcome user and more icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                "Welcome, ${supabase.auth.currentUser?.userMetadata?["username"]}!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
        ),
        // current expense and remaining budget side by side
        Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Current Expense:\n\$1280.00",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Remaining Budget:\n\$720.00",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        // recent activities list
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Recent Activities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text("Dinner at Sushi Place"),
              subtitle: Text("Expense: \$190"),
              trailing: Text("Jan 12"),
            ),
            ListTile(
              leading: Icon(Icons.local_cafe),
              title: Text("Coffee at Cafe de Flore"),
              subtitle: Text("Expense: \$20"),
              trailing: Text("Jan 11"),
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text("Dinner at Le Meurice"),
              subtitle: Text("Expense: \$150"),
              trailing: Text("Jan 11"),
            ),
            ListTile(
              leading: Icon(Icons.local_gas_station),
              title: Text("Car Fuel"),
              subtitle: Text("Expense: \$20"),
              trailing: Text("Jan 11"),
            ),
            ListTile(
              leading: Icon(Icons.hotel),
              title: Text("Hotel Booking"),
              subtitle: Text("Expense: \$400"),
              trailing: Text("Jan 10"),
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text("Car Rental"),
              subtitle: Text("Expense: \$200"),
              trailing: Text("Jan 10"),
            ),
            ListTile(
              leading: Icon(Icons.flight_takeoff),
              title: Text("Flight to Paris"),
              subtitle: Text("Expense: \$300"),
              trailing: Text("Jan 10"),
            ),
          ],
        ),
      ],
    );
  }
}

class HomePageFloatingActionButton extends StatelessWidget {
  const HomePageFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
