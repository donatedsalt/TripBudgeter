import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';

final tripsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) {
    return [];
  }

  final data = await supabase
      .from('trips')
      .select()
      .eq('user_id', userId)
      .order('date', ascending: false);

  return data;
});
