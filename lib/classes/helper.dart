import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:nyoom/classes/data_models/bus_services.dart';

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

  static Future<List<BusServices>> loadBusServices() async {
    final data = await Helper.readJSON('bus_services.json'); 

    return (data as List).map((item) => BusServices.fromJson(item)).toList();
  }
}
