import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/helper.dart';

class StaticData {
  static Future<List<String>> busServices() async {
    final data = await Helper.readJSON('bus_services.json');
    return List<String>.from(data);
  }

  static Future<List<BusStop>> busStops() async {
    final data = await Helper.readJSON('bus_stops_complete.json');
    return (data as List).map((item) => BusStop.fromJson(item)).toList();
  }

  static Future<Map<String, List<String>>> busServicesAtStop() async {
    final data = await Helper.readJSON('bus_services_at_stop.json');
    return (data as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, List<String>.from(value)),
    );
  }

  static Future<Map<String, Map<String, List<dynamic>>>> busStopsMap() async {
    final data = await Helper.readJSON('busstops_map.json');
    return (data as Map<String, dynamic>).map(
      (key1, value1) => MapEntry(
        key1,
        (value1 as Map<String, dynamic>).map((key2, value2) {
          if (value2 is String) {
            return MapEntry(key2, [value2]);
          }
          if (value2 is List) {
            return MapEntry(key2, value2); // keep as dynamic list
          }
          return MapEntry(key2, []);
        }),
      ),
    );
  }
}
