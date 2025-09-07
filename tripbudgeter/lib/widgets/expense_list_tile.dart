import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/providers/expense_categories_provider.dart';

/// A custom ListTile widget for displaying an expense with an icon based on its category.
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

        final iconData = category.containsKey('icon')
            ? IconData(
                int.parse('0x${category['icon']}'),
                fontFamily: 'MaterialIcons',
              )
            : Icons.receipt;

        return ListTile(
          leading: Icon(iconData),
          title: Text(expense['name']),
          subtitle: Text(
            "Expense: \$${(expense['amount'] as num).toDouble().toStringAsFixed(2)}",
          ),
          trailing: Text(
            expense['time'].toString().split(' ').join('\n'),
            textAlign: TextAlign.right,
          ),
        );
      },
    );
  }
}
