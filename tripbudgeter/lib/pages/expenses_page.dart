import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/providers/expenses_provider.dart';
import 'package:tripbudgeter/providers/trips_provider.dart';

import 'package:tripbudgeter/widgets/expense_list_tile.dart';

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

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsyncValue = ref.watch(tripsProvider);
    final expensesAsyncValue = ref.watch(expensesProvider);

    return tripsAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (trips) {
        final currentTrip = trips.firstWhere(
          (trip) => trip['is_current'],
          orElse: () => {},
        );

        if (currentTrip.isEmpty) {
          return const Center(child: Text("No current trip found."));
        }

        return expensesAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (expenses) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Current Trip
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Trip",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.flight_takeoff),
                        title: Text(currentTrip['name']),
                        subtitle: Text(
                          "\$${currentTrip['spent'].toStringAsFixed(2)} / \$${currentTrip['budget'].toStringAsFixed(2)}",
                        ),
                        trailing: Text(currentTrip['date']),
                        tileColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),

                // Expenses list
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    const Text(
                      "Expenses",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (expenses.isEmpty)
                      const Center(
                        child: Text("No expenses added for this trip."),
                      )
                    else
                      ...expenses.map((expense) {
                        return ExpenseListTile(expense: expense);
                      }),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ExpensesPageFloatingActionButton extends StatelessWidget {
  const ExpensesPageFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/expense/add');
      },
      child: const Icon(Icons.add),
    );
  }
}
