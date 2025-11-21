import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/static_data.dart';

void testFunction(WidgetRef ref) async {
  final data = await StaticData.busStops();
  String b = "";
  for (BusStop a in data) {
    if (b.length < a.busStopName.length)
    {
      b = a.busStopName;
    }
  }
  print(b);
}
