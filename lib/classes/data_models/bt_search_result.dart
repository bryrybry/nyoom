import 'package:hive/hive.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';

part 'bt_search_result.g.dart';

@HiveType(typeId: 2)
class BTSearchResult {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String value;
  @HiveField(2)
  final String header;
  @HiveField(3)
  final String subheader1;
  @HiveField(4)
  final String subheader2;

  BTSearchResult({
    required this.type,
    required this.value,
    required this.header,
    required this.subheader1,
    required this.subheader2,
  });

  factory BTSearchResult.fromJson(Map<String, dynamic> json) {
    return BTSearchResult(
      type: json["type"],
      value: json["value"],
      header: json["header"],
      subheader1: json["subheader1"],
      subheader2: json["subheader2"],
    );
  }

  factory BTSearchResult.fromBusService(BusService busService) {
    return BTSearchResult(
      type: "busService",
      value: busService.busService,
      header: busService.busService,
      subheader1: "Bus Service",
      subheader2: "",
    );
  }
  factory BTSearchResult.fromBusStop(BusStop stop) {
    return BTSearchResult(
      type: "busStop",
      value: stop.busStopCode,
      header: stop.busStopName,
      subheader1: stop.busStopCode,
      subheader2: stop.roadName,
    );
  }
}
