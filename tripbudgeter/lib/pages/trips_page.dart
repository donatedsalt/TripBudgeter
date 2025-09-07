import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/providers/trips_provider.dart';

import 'package:tripbudgeter/widgets/trip_list_tile.dart';

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

class TripsPage extends ConsumerWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsyncValue = ref.watch(tripsProvider);

    return tripsAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (trips) {
        final currentTrip = trips.firstWhere(
          (trip) => trip["is_current"],
          orElse: () => {},
        );

        final completedTrips = trips
            .where((trip) => !trip["is_current"])
            .toList();

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Current Trip Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Trip",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                if (currentTrip.isEmpty)
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("No current trip"),
                    subtitle: const Text("Add a new trip to get started"),
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.flight_takeoff),
                    title: Text(currentTrip["name"]),
                    subtitle: Text(
                      "\$${currentTrip["spent"]} / \$${currentTrip["budget"]}",
                    ),
                    trailing: Text(currentTrip["date"]),
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
              ],
            ),

            // Completed Trips list section
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Completed Trips",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                ...completedTrips.map((trip) => TripListTile(trip: trip)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TripsPageFloatingActionButton extends StatelessWidget {
  const TripsPageFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, "/trip/add");
      },
      child: Icon(Icons.add),
    );
  }
}
