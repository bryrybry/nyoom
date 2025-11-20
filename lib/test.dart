import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/services/api_service.dart';

void testFunction(WidgetRef ref) async {
  print(ref.read(bookmarksProvider.notifier).getBookmarks());
}
