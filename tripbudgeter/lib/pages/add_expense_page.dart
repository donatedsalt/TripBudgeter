import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';
import 'package:tripbudgeter/utils/context_extension.dart';

import 'package:tripbudgeter/providers/trips_provider.dart';
import 'package:tripbudgeter/providers/expenses_provider.dart';
import 'package:tripbudgeter/providers/expense_categories_provider.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  const AddExpensePage({super.key});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _submitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Map<String, dynamic>? _selectedCategory;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _submitting = true;
        });

        final trips = ref.read(tripsProvider).value;
        final currentTrip = trips?.firstWhere((trip) => trip["is_current"]);

        if (currentTrip == null) {
          if (mounted) {
            context.showSnackBar("No current trip found.", isError: true);
          }
          return;
        }

        final tripId = currentTrip['id'];

        await supabase.from('expenses').insert({
          'trip_id': tripId,
          'user_id': supabase.auth.currentUser?.id,
          'name': _nameController.text,
          'amount': double.parse(_amountController.text),
          'time': _timeController.text,
          'category_id': _selectedCategory!['id'],
        });

        final newSpent =
            (currentTrip['spent'] as num).toDouble() +
            double.parse(_amountController.text);
        await supabase
            .from('trips')
            .update({'spent': newSpent})
            .eq('id', tripId)
            .eq('user_id', supabase.auth.currentUser?.id ?? "");

        if (mounted) {
          ref.invalidate(expensesProvider);
          ref.invalidate(tripsProvider);
          context.showSnackBar("Expense added successfully!");
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          context.showSnackBar("Failed to add expense: $e", isError: true);
        }
      } finally {
        if (mounted) {
          setState(() {
            _submitting = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(expensesCategoriesProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Expense',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        ),

        body: categoriesAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (categories) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                children: [
                  // expense name field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Expense Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),

                  // expense amount field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Expense Amount',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),

                  // expense category dropdown
                  DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: const InputDecoration(
                      labelText: 'Expense Category',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _selectedCategory,
                    onChanged: (Map<String, dynamic>? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: category,
                        child: Text(category['name']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),

                  // expense date time field
                  TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Expense Time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 5),
                        ),
                      );
                      if (!context.mounted) return;
                      var time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          );
                        },
                      );
                      if (date != null && time != null) {
                        _timeController.text =
                            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                      }
                    },
                    readOnly: true,
                  ),
                ],
              ),
            );
          },
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton.outlined(
                  onPressed: () {
                    _submitting ? null : Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: IconButton.filled(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Icon(Icons.check),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
