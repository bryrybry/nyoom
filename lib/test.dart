// ignore_for_file: unused_import

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/providers/appdata_provider.dart';
import 'package:nyoom/services/api_service.dart';

void testFunction(WidgetRef ref) async {
  print(
    (await ApiService.onemapSearch(
      ref,
      "singapore polytechnic",
    )).map((e) => e.searchVal).toList(),
  );
}
