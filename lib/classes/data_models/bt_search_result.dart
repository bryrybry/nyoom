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
  final String? distanceSubheader;

  BTSearchResult({
    required this.type,
    required this.value,
    required this.header,
    required this.subheader1,
    required this.subheader2,
    this.distanceSubheader
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
  factory BTSearchResult.fromNearbyBusStop(NearbyBusStop stop) {
    return BTSearchResult(
      type: "busStop",
      value: stop.busStop.busStopCode,
      header: stop.busStop.busStopName,
      subheader1: stop.busStop.busStopCode,
      subheader2: stop.busStop.roadName,
      distanceSubheader: "${stop.distance.round()}m"
    );
  }
  factory BTSearchResult.cleanDistanceSubheader(BTSearchResult searchResult) {
    return BTSearchResult(
      type: searchResult.type,
      value: searchResult.value,
      header: searchResult.header,
      subheader1: searchResult.subheader1,
      subheader2: searchResult.subheader2,
    );
  }
}
