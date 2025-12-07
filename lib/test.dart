import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/providers/appdata_provider.dart';

void testFunction(WidgetRef ref) async {
  final notifier = ref.read(appDataProvider.notifier);

  print(notifier.state.btSearchResultsCache.map((e) => e.header));
  print(notifier.state.btSearchResultsCache.length);

  notifier.clearSearchResultCache();

  // Read updated state
  print(notifier.state.btSearchResultsCache.map((e) => e.header));
  print(notifier.state.btSearchResultsCache.length);
}
