import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';
import 'package:tripbudgeter/utils/context_extension.dart';

import 'package:tripbudgeter/providers/trips_provider.dart';

/// A custom ListTile widget for displaying a trip.
/// with swipe-to-set-current and swipe-to-delete functionality.
class TripListTile extends ConsumerWidget {
  const TripListTile({super.key, required this.trip});

  final Map<String, dynamic> trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Icon(Icons.arrow_circle_up, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDeleteDialog(context, ref) ?? false;
        }
        return true;
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await supabase
              .from('trips')
              .update({'is_current': false})
              .eq('is_current', true);
          await supabase
              .from('trips')
              .update({'is_current': true})
              .eq('id', trip['id']);
          ref.invalidate(tripsProvider);
          if (context.mounted) context.showSnackBar('Trip set as current!');
        } else if (direction == DismissDirection.endToStart) {
          context.showSnackBar('Trip deleted!');
        }
      },
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline),
        title: Text(trip["name"]),
        subtitle: Text("\$${trip["spent"]} / \$${trip["budget"]}"),
        trailing: Text(trip["date"]),
      ),
    );
  }

  Future<bool?> showDeleteDialog(BuildContext context, WidgetRef ref) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this trip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await supabase.from('trips').delete().eq('id', trip['id']);
              if (trip['is_current'] == true) {
                final trips = await supabase
                    .from('trips')
                    .select()
                    .order('date', ascending: true);
                if (trips.isNotEmpty) {
                  await supabase
                      .from('trips')
                      .update({'is_current': true})
                      .eq('id', trips[0]['id']);
                  ref.invalidate(tripsProvider);
                }
              }
              ref.invalidate(tripsProvider);
              if (context.mounted) Navigator.of(context).pop(true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
