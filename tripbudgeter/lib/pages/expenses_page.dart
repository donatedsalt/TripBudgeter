import 'package:flutter/material.dart';

class ExpensesPageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ExpensesPageAppBar({super.key});

  @override
  State<ExpensesPageAppBar> createState() => _ExpensesPageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ExpensesPageAppBarState extends State<ExpensesPageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Expenses',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
    );
  }
}

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
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
        // Expenses list
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Expenses",
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

class ExpensesPageFloatingActionButton extends StatelessWidget {
  const ExpensesPageFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {}, child: Icon(Icons.add));
  }
}
