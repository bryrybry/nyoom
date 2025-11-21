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
}
