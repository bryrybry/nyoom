import 'package:ntp/ntp.dart';

class BusArrival {
  final List<_BusService> services;

  BusArrival({required this.services});

  static Future<BusArrival> fromJson(Map<String, dynamic> json) async {
    final servicesJson = json["Services"] as List<dynamic>? ?? [];
    final services = await Future.wait(
      servicesJson.map((s) => _BusService.fromJson(s)).toList(),
    );
    return BusArrival(services: services);
  }
}

class _BusService {
  final String serviceNo;
  final _BusTiming nextBus;
  final _BusTiming nextBus2;
  final _BusTiming nextBus3;

  _BusService({
    required this.serviceNo,
    required this.nextBus,
    required this.nextBus2,
    required this.nextBus3,
  });

  static Future<_BusService> fromJson(Map<String, dynamic> json) async {
  Future<_BusTiming> parseBusTiming(dynamic data) async {
    if (data == null || data is! Map<String, dynamic>) {
      // Provide a default timing when missing
      return _BusTiming(
        arrivalTime: -1,
        isDoubleDecker: false,
        isEstimatedTime: false,
        isWheelchairAccessible: false,
        load: BusLoad.sea,
      );
    }
    return await _BusTiming.fromJson(data);
  }

  return _BusService(
    serviceNo: json["ServiceNo"] ?? "",
    nextBus: await parseBusTiming(json["NextBus"]),
    nextBus2: await parseBusTiming(json["NextBus2"]),
    nextBus3: await parseBusTiming(json["NextBus3"]),
  );
}

}

enum BusLoad { sea, sda, lsd }

class _BusTiming {
  final int arrivalTime;
  final bool isDoubleDecker;
  final bool isEstimatedTime;
  final bool isWheelchairAccessible;
  final BusLoad load;

  _BusTiming({
    required this.arrivalTime,
    required this.isDoubleDecker,
    required this.isEstimatedTime,
    required this.isWheelchairAccessible,
    required this.load,
  });

  static Future<_BusTiming> fromJson(Map<String, dynamic> json) async {
    return _BusTiming(
      arrivalTime: await minutesFromNow(json["EstimatedArrival"]),
      isDoubleDecker: json["Type"] == "DD",
      isEstimatedTime: json["Monitored"] == 1,
      isWheelchairAccessible: json["Feature"] == "WAB",
      load: switch (json["Load"]) {
        "SEA" => BusLoad.sea,
        "SDA" => BusLoad.sda,
        "LSD" => BusLoad.lsd,
        _ => BusLoad.sea,
      },
    );
  }

  static Future<int> minutesFromNow(String targetISOTimestamp) async {
    final target = DateTime.parse(
      targetISOTimestamp,
    ).toUtc().add(Duration(hours: 8));
    late DateTime now;
    try {
      now = (await NTP.now()).toUtc().add(Duration(hours: 8));
    } catch (e) {
      now = DateTime.now().toUtc().add(Duration(hours: 8));
    }
    final diff = target.difference(now);
    return diff.inMinutes;
  }
}
