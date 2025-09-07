import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';

import 'package:tripbudgeter/providers/trips_provider.dart';

final expensesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final tripsAsyncValue = ref.watch(tripsProvider);

  final trips = tripsAsyncValue.value;

  final currentTrip = trips?.firstWhere(
    (trip) => trip["is_current"],
    orElse: () => {},
  );

  if (currentTrip?.isEmpty ?? true) {
    return [];
  }

  final tripId = currentTrip!['id'];
  final data = await supabase
      .from('expenses')
      .select()
      .eq('trip_id', tripId)
      .order('time', ascending: false);

  return data;
});
