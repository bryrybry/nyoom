import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

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

  static Future<List<String>> loadBusServices() async {
    return await Helper.readJSON('bus_services.json'); 
  }
}
