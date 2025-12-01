import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/providers/appdata_provider.dart';

void testFunction(WidgetRef ref) async {
  print(ref.read(appDataProvider).isGuestMode);
}
