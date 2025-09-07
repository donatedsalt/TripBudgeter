import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';

import 'package:tripbudgeter/providers/trips_provider.dart';
import 'package:tripbudgeter/providers/expenses_provider.dart';

import 'package:tripbudgeter/widgets/expense_list_tile.dart';

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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsyncValue = ref.watch(tripsProvider);
    final expensesAsyncValue = ref.watch(expensesProvider);

    return tripsAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (trips) {
        final currentTrip = trips.firstWhere(
          (trip) => trip["is_current"],
          orElse: () => {},
        );

        final spent = (currentTrip['spent'] as num?)?.toDouble() ?? 0.0;
        final budget = (currentTrip['budget'] as num?)?.toDouble() ?? 0.0;
        final remaining = budget - spent;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // welcome user and more icon
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                "Welcome, ${supabase.auth.currentUser?.userMetadata?["username"] ?? 'User'}!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // current expense and remaining budget side by side
            if (currentTrip.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Current Expense
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryFixed,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Current Expense:\n\$${spent.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8.0),

                  // Remaining Budget
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryFixed,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Remaining Budget:\n\$${remaining.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("No current trip"),
                  subtitle: const Text("Add a new trip to get started"),
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),

            // recent activities list
            expensesAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (expenses) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Activities",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (expenses.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return ExpenseListTile(expense: expense);
                        },
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text("No recent activities"),
                          subtitle: const Text(
                            "All your expenses will show up here.",
                          ),
                          tileColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class HomePageFloatingActionButton extends StatelessWidget {
  const HomePageFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/expense/add');
      },
      child: Icon(Icons.add),
    );
  }
}
