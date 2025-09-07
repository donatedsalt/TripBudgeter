import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/icon_map.dart';
import 'package:tripbudgeter/utils/supabase_config.dart';
import 'package:tripbudgeter/utils/context_extension.dart';

import 'package:tripbudgeter/providers/expenses_provider.dart';
import 'package:tripbudgeter/providers/expense_categories_provider.dart';

/// A custom ListTile widget for displaying an expense with an icon based on its category.
/// with swipe-to-delete functionality.
class ExpenseListTile extends ConsumerWidget {
  const ExpenseListTile({super.key, required this.expense});

  final Map<String, dynamic> expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(expensesCategoriesProvider);

    return categoriesAsyncValue.when(
      loading: () => const ListTile(
        leading: Icon(Icons.receipt),
        title: Text('Loading...'),
      ),
      error: (err, stack) => const ListTile(
        leading: Icon(Icons.error),
        title: Text('Error loading category'),
      ),
      data: (categories) {
        final category = categories.firstWhere(
          (cat) => cat['id'] == expense['category_id'],
          orElse: () => {'icon': 'receipt'},
        );

        final iconData = iconMap[category['icon']] ?? Icons.receipt;

        return Dismissible(
          key: UniqueKey(),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Deletion'),
                content: const Text(
                  'Are you sure you want to delete this expense?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      await supabase
                          .from('expenses')
                          .delete()
                          .eq('id', expense['id']);
                      ref.invalidate(expensesProvider);
                      if (context.mounted) {
                        context.showSnackBar('Expense deleted!');
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: ListTile(
            leading: Icon(iconData),
            title: Text(expense['name']),
            subtitle: Text(
              "Expense: \$${(expense['amount'] as num).toDouble().toStringAsFixed(2)}",
            ),
            trailing: Text(
              expense['time'].toString().split(' ').join('\n'),
              textAlign: TextAlign.right,
            ),
          ),
        );
      },
    );
  }
}
