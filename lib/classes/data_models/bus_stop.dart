class BusStop {
  final String busStopCode;
  final String roadName;
  final String description;
  final double latitude;
  final double longitude;

  BusStop({
    required this.busStopCode,
    required this.roadName,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      busStopCode: json["BusStopCode"],
      roadName: json["RoadName"],
      description: json["Description"],
      latitude: (json["Latitude"] as num).toDouble(),
      longitude: (json["Longitude"] as num).toDouble(),
    );
  }
}
