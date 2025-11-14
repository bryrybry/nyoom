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
    return (data as Map<String, dynamic>).map((key, value) => MapEntry(key, List<String>.from(value)));
  }
}
