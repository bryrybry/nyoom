import 'package:nyoom/classes/data_models/bus_times_search_result.dart';

class BusStop {
  final String busStopCode;
  final String roadName;
  final String busStopName;
  final double? latitude;
  final double? longitude;

  BusStop({
    required this.busStopCode,
    required this.roadName,
    required this.busStopName,
    this.latitude,
    this.longitude,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      busStopCode: json["BusStopCode"],
      roadName: json["RoadName"],
      busStopName: json["Description"],
      latitude: (json["Latitude"] as num).toDouble(),
      longitude: (json["Longitude"] as num).toDouble(),
    );
  }

  factory BusStop.fromSearchResult(BTSearchResult searchResult) {
    return BusStop(
      busStopCode: searchResult.value,
      roadName: searchResult.subheader2,
      busStopName: searchResult.header,
    );
  }
}

class BusStopAT extends BusStop {
  final List<String> arrivalTimes;

  BusStopAT({
    required super.busStopCode,
    required super.roadName,
    required super.busStopName,
    super.latitude,
    super.longitude,
    required this.arrivalTimes,
  });

  factory BusStopAT.fromBusStopCode(
    String busStopCode,
    List<String> arrivalTimes,
    List<BusStop> busStops,
  ) {
    for (BusStop busStop in busStops) {
      if (busStop.busStopCode == busStopCode) {
        return BusStopAT(
          busStopCode: busStop.busStopCode,
          roadName: busStop.roadName,
          busStopName: busStop.busStopName,
          arrivalTimes: arrivalTimes,
        );
      }
    }
    throw Error();
  }
}
