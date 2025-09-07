import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';
import 'package:tripbudgeter/utils/context_extension.dart';

import 'package:tripbudgeter/providers/trips_provider.dart';

class AddTripPage extends ConsumerStatefulWidget {
  const AddTripPage({super.key});

  @override
  ConsumerState<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends ConsumerState<AddTripPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _submitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _submitting = true;
        });

        await supabase
            .from('trips')
            .update({'is_current': false})
            .eq('user_id', supabase.auth.currentUser?.id ?? "");

        await supabase.from('trips').insert({
          'user_id': supabase.auth.currentUser?.id,
          'name': _nameController.text,
          'budget': double.parse(_budgetController.text),
          'spent': 0.0,
          'date': _dateController.text,
          'is_current': true,
        });

        if (mounted) {
          ref.invalidate(tripsProvider);
          context.showSnackBar("Trip added successfully!");
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          context.showSnackBar("Failed to add trip: $e", isError: true);
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
    _budgetController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Trip',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _submitting ? null : Navigator.pop(context);
            },
          ),
        ),

        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            children: [
              const Text(
                "Adding a new trip will make it your current trip.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24.0),

              // trip name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Trip Name',
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

              // trip budget field
              TextFormField(
                controller: _budgetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Trip Budget',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
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

              // trip date field
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Trip Date',
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
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (date != null) {
                    _dateController.text =
                        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}";
                  }
                },
                readOnly: true,
              ),
            ],
          ),
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
