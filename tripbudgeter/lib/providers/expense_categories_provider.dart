import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';

final expensesCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await supabase.from('expense_categories').select();
  return response;
});
