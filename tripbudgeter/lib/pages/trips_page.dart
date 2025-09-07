import 'package:flutter/material.dart';
import 'package:tripbudgeter/main.dart';

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

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  bool _loading = false;

  List<Map<String, dynamic>> _trips = [];
  Map<String, dynamic> _currentTrip = {};

  void fetchTrips() async {
    setState(() {
      _loading = true;
    });
    final data = await supabase
        .from('trips')
        .select()
        .eq('user_id', supabase.auth.currentUser?.id ?? "")
        .order('date', ascending: false);
    if (mounted) {
      setState(() {
        _trips = data;
        _currentTrip = _trips.firstWhere(
          (trip) => trip["is_current"],
          orElse: () => {},
        );
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    fetchTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: EdgeInsets.all(16.0),
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
            _currentTrip.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("No current trip"),
                      subtitle: Text("Add a new trip to get started"),
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.flight_takeoff),
                      title: Text(_currentTrip["name"]),
                      subtitle: Text(
                        "\$${_currentTrip["spent"]} / \$${_currentTrip["budget"]}",
                      ),
                      trailing: Text(_currentTrip["date"]),
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
          ],
        ),
        // Completed Trips list
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Completed Trips",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                return Column(
                  children: _trips
                      .where((trip) => !trip["is_current"])
                      .map(
                        (trip) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.check_circle_outline),
                            title: Text(trip["name"]),
                            subtitle: Text(
                              "\$${trip["spent"]} / \$${trip["budget"]}",
                            ),
                            trailing: Text(trip["date"]),
                            tileColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ],
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
