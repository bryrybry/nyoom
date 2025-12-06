import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';

class BusArrival {
  final List<BusArrivalService> services;

  BusArrival({required this.services});

  static Future<BusArrival> fromJson(Map<String, dynamic> json) async {
    final servicesJson = json["Services"] as List<dynamic>? ?? [];
    final services = await Future.wait(
      servicesJson.map((s) => BusArrivalService.fromJson(s)).toList(),
    );
    return BusArrival(services: services);
  }
}

class BusArrivalService {
  final String serviceNo;
  final _BusTiming nextBus;
  final _BusTiming nextBus2;
  final _BusTiming nextBus3;

  BusArrivalService({
    required this.serviceNo,
    required this.nextBus,
    required this.nextBus2,
    required this.nextBus3,
  });

  static BusArrivalService defaultBusArrivalService() {
    return BusArrivalService(
      serviceNo: "",
      nextBus: _BusTiming.defaultBusTiming(),
      nextBus2: _BusTiming.defaultBusTiming(),
      nextBus3: _BusTiming.defaultBusTiming(),
    );
  }

    static BusArrivalService initBusArrivalService() {
    return BusArrivalService(
      serviceNo: "",
      nextBus: _BusTiming.initBusTiming(),
      nextBus2: _BusTiming.initBusTiming(),
      nextBus3: _BusTiming.initBusTiming(),
    );
  }

  static BusArrivalService defaultBusArrivalService2() {
    return BusArrivalService(
      serviceNo: "",
      nextBus: _BusTiming.defaultBusTiming2(),
      nextBus2: _BusTiming.defaultBusTiming2(),
      nextBus3: _BusTiming.defaultBusTiming2(),
    );
  }

  static Future<BusArrivalService> fromJson(Map<String, dynamic> json) async {
    Future<_BusTiming> parseBusTiming(dynamic data) async {
      if (data == null || data is! Map<String, dynamic>) {
        // Provide a default timing when missing
        return _BusTiming.defaultBusTiming();
      }
      return await _BusTiming.fromJson(data);
    }

    return BusArrivalService(
      serviceNo: json["ServiceNo"] ?? "",
      nextBus: await parseBusTiming(json["NextBus"]),
      nextBus2: await parseBusTiming(json["NextBus2"]),
      nextBus3: await parseBusTiming(json["NextBus3"]),
    );
  }
}

class _BusTiming {
  final int arrivalTime;
  final bool isDoubleDecker;
  final bool isEstimatedTime;
  final bool isWheelchairAccessible;
  final String load;

  _BusTiming({
    required this.arrivalTime,
    required this.isDoubleDecker,
    required this.isEstimatedTime,
    required this.isWheelchairAccessible,
    required this.load,
  });

  static _BusTiming defaultBusTiming() {
    return _BusTiming(
      arrivalTime: -1,
      isDoubleDecker: false,
      isEstimatedTime: false,
      isWheelchairAccessible: false,
      load: "SEA",
    );
  }
  
  static _BusTiming initBusTiming() {
    return _BusTiming(
      arrivalTime: -2,
      isDoubleDecker: false,
      isEstimatedTime: false,
      isWheelchairAccessible: false,
      load: "SEA",
    );
  }

  static _BusTiming defaultBusTiming2() {
    return _BusTiming(
      arrivalTime: -3,
      isDoubleDecker: false,
      isEstimatedTime: false,
      isWheelchairAccessible: false,
      load: "SEA",
    );
  }

  static Future<_BusTiming> fromJson(Map<String, dynamic> json) async {
    return _BusTiming(
      arrivalTime: await minutesFromNow(json["EstimatedArrival"]),
      isDoubleDecker: json["Type"] == "DD",
      isEstimatedTime: json["Monitored"] == 1,
      isWheelchairAccessible: json["Feature"] == "WAB",
      load: json["Load"],
    );
  }

  static Future<int> minutesFromNow(String targetISOTimestamp) async {
    DateTime target;
    if (targetISOTimestamp.isEmpty) {
      return -1;
    }
    try {
      target = DateTime.parse(
        targetISOTimestamp,
      ).toUtc().add(Duration(hours: 8));
    } catch (e) {
      if (kDebugMode) {
        print('Failed to parse timestamp: "$targetISOTimestamp"');
      }
      return -1;
    }

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
