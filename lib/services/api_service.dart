import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/services/dio.dart';

class ApiService {
  static Future<BusArrival> busArrival(String busStopCode) async {
  final response = await DatamallApiService.dio.get(
    '/BusArrival',
    queryParameters: {'BusStopCode': busStopCode},
  );
  return await BusArrival.fromJson(response.data);
}

  static Future<List<dynamic>> busArrivalMultiqueue(
    List<String> busStopCodes,
    String serviceNo,
  ) async {
    final futures = busStopCodes.map((code) {
      return DatamallApiService.dio.get(
        '/BusArrival',
        queryParameters: {'BusStopCode': code, 'ServiceNo': serviceNo},
      );
    });

    final results = await Future.wait(futures);

    return results.map((r) => r.data).toList();
  }
}
