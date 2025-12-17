// ignore_for_file: unused_import

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/providers/appdata_provider.dart';

void testFunction(WidgetRef ref) async {
  await _getApiKey();
}

Future<void> _getApiKey() async {
  try {
    final key = await const MethodChannel(
      'flutter/key_test',
    ).invokeMethod<String>('getGoogleMapsApiKey');
    print(
      'Google Maps API Key: ${key ?? 'Not found'}',
    ); // Will print in debug console
  } on PlatformException catch (e) {
    print('Error fetching API key: $e');
  }
}
