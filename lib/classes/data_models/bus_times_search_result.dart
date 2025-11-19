import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';

class BTSearchResult {
  final String type;
  final String value;
  final String header;
  final String subheader1;
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
