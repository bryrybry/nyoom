import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'package:ntp/ntp.dart';
import 'package:nyoom/classes/static_data.dart';

class Helper {
  static Future<dynamic> readJSON(String fileName) async {
    return json.decode(await readJSONString(fileName));
  }

  static Future<String> readJSONString(String fileName) async {
    try {
      String data = await rootBundle.loadString('assets/data/$fileName');
      return data;
    } catch (e) {
      if (kDebugMode) {
        throw ('Error reading JSON file: $e');
      }
      return "";
    }
  }

  static String twoLineTextBalancer(String text, int threshold) {
    if (text.length <= threshold) {
      return text;
    }
    int mid = (text.length / 2).round();
    int split = text.lastIndexOf(' ', mid);
    if (split == -1) {
      split = text.indexOf(' ', mid);
    }
    if (split == -1) {
      split = mid;
    }
    return '${text.substring(0, split).trim()}\n${text.substring(split).trim()}';
  }

  static Future<bool> isWithinServiceHours(
    String busService,
    String busStopCode,
  ) async {
    Map<String, Map<String, Map<String, String>>> firstLastBus =
        await StaticData.firstLastBus();
    Map<String, String> serviceHours = firstLastBus[busService]![busStopCode]!;

    // Get SG time
    late DateTime now;
    try {
      now = (await NTP.now()).toUtc().add(Duration(hours: 8));
    } catch (e) {
      now = DateTime.now().toUtc().add(Duration(hours: 8));
    }

    // Determine day key: WD / SAT / SUN
    String dayKey;
    switch (now.weekday) {
      case DateTime.saturday:
        dayKey = "SAT";
        break;
      case DateTime.sunday:
        dayKey = "SUN";
        break;
      default:
        dayKey = "WD";
    }

    // Extract first + last bus times (e.g. "0601")
    final firstStr = serviceHours["${dayKey}_FirstBus"];
    final lastStr = serviceHours["${dayKey}_LastBus"];

    if (firstStr == null ||
        lastStr == null ||
        firstStr == "-" ||
        lastStr == "-" ||
        firstStr.length < 4 ||
        lastStr.length < 4) {
      return false;
    }

    // Convert HHMM → DateTime
    DateTime todayFirst = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(firstStr.substring(0, 2)),
      int.parse(firstStr.substring(2)),
    );

    DateTime todayLast = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(lastStr.substring(0, 2)),
      int.parse(lastStr.substring(2)),
    );

    // Handle overnight last bus (e.g. 00:24 next day)
    if (todayLast.isBefore(todayFirst)) {
      todayLast = todayLast.add(Duration(days: 1));
    }

    return now.isAfter(todayFirst) && now.isBefore(todayLast);
  }

  Future<Position?> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}
