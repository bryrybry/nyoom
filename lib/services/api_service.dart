import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/services/dio.dart';

class ApiService {
  static Future<BusArrivalService> busArrival(
    String busStopCode,
    String serviceNo,
  ) async {
    final response = await DatamallApiService.dio.get(
      '/BusArrival',
      queryParameters: {'BusStopCode': busStopCode, 'ServiceNo': serviceNo},
    );
    final busArrival = await BusArrival.fromJson(response.data);
    if (busArrival.services.isEmpty) {
      return BusArrivalService.defaultBusArrivalService();
    }
    return busArrival.services.first;
  }

  static Future<List<BusArrivalService>> busArrivalMultiqueue({
    required List<String> busStopCodes,
    required List<String> busServices,
  }) async {
    // Build all (busStopCode, serviceNo) pairs
    final requestPairs = <MapEntry<String, String>>[];

    if (busStopCodes.length > 1 && busServices.length == 1) {
      // Multiple stops, single service
      for (final stop in busStopCodes) {
        requestPairs.add(MapEntry(stop, busServices.first));
      }
    } else if (busStopCodes.length == 1 && busServices.length > 1) {
      // Single stop, multiple services
      for (final service in busServices) {
        requestPairs.add(MapEntry(busStopCodes.first, service));
      }
    } else if (busStopCodes.length == 1 && busServices.length == 1) {
      // Single stop, single service
      requestPairs.add(MapEntry(busStopCodes.first, busServices.first));
    } else {
      throw ArgumentError(
        "Invalid input: only multiple stops/one service or multiple services/one stop is allowed",
      );
    }

    final futures = requestPairs.map((pair) async {
      try {
        final response = await DatamallApiService.dio.get(
          '/BusArrival',
          queryParameters: {'BusStopCode': pair.key, 'ServiceNo': pair.value},
        );

        final busArrival = await BusArrival.fromJson(response.data);

        if (busArrival.services.isEmpty) {
          return BusArrivalService.defaultBusArrivalService();
        }

        return busArrival.services.first;
      } catch (e) {
        // Log and return fallback instead of crashing
        print(
          "Failed bus arrival request for stop ${pair.key}, service ${pair.value}: $e",
        );

        return BusArrivalService.defaultBusArrivalService();
      }
    }).toList();

    return Future.wait(futures);
  }
}
