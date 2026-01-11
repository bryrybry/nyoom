import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/classes/data_models/onemap_search_result.dart';
// import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/services/dio.dart';

enum APIServiceResult { success, noInternet, serverError }

class ApiService {
  static Future<BusArrivalService> busArrival(
    String busStopCode,
    String serviceNo,
  ) async {
    try {
      final response = await DatamallApiService.dio.get(
        '/BusArrival',
        queryParameters: {'BusStopCode': busStopCode, 'ServiceNo': serviceNo},
      );
      final busArrival = await BusArrival.fromJson(response.data);
      if (busArrival.services.isEmpty) {
        // if (await Helper.isWithinServiceHours(serviceNo, busStopCode)) {
        //   return BusArrivalService.defaultBusArrivalService2();
        // }
        return BusArrivalService.defaultBusArrivalService();
      }
      return busArrival.services.first;
    } on DioException catch (_) {
      return BusArrivalService.defaultBusArrivalService();
    }
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
          // if (await Helper.isWithinServiceHours(pair.value, pair.key)) {
          //   return BusArrivalService.defaultBusArrivalService2();
          // }
          return BusArrivalService.defaultBusArrivalService();
        }

        return busArrival.services.first;
      } catch (e) {
        // Log and return fallback instead of crashing
        if (kDebugMode) {
          print(
            "Failed bus arrival request for stop ${pair.key}, service ${pair.value}: $e",
          );
        }

        return BusArrivalService.defaultBusArrivalService();
      }
    }).toList();

    return Future.wait(futures);
  }

  static Future<List<BusArrivalService>> busArrivalMultiqueueByPairs(
    List<MapEntry<String, String>> pairs,
  ) async {
    return await Future.wait(pairs.map((p) => busArrival(p.key, p.value)));
  }

  static Future<APIServiceResult> sendTelegramFeedback(
    String feedbackContent,
  ) async {
    try {
      await TelegramApiService.dio.get(
        '/sendMessage',
        queryParameters: {
          'chat_id': dotenv.env['TELEGRAM_FEEDBACK_CHAT_ID'],
          'text': feedbackContent,
        },
      );
      return APIServiceResult.success;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return APIServiceResult.noInternet;
      }

      if (e.response != null) {
        if (kDebugMode) {
          print('Telegram error: ${e.response?.statusCode}');
        }
      }

      return APIServiceResult.serverError;
    }
  }

  static Future<Map<String, dynamic>> getNewOnemapAccessToken() async {
    try {
      final response = await OnemapApiService.dio.post(
        '/auth/post/getToken',
        data: {
          "email": dotenv.env['ONEMAP_EMAIL'],
          "password": dotenv.env['ONEMAP_PASSWORD'],
        },
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (kDebugMode) {
          print('Onemap auth error: ${e.response?.statusCode}');
        }
      }

      return {};
    }
  }

  static Future<List<OnemapSearchResult>> onemapSearch(
    WidgetRef ref,
    String searchValue,
  ) async {
    try {
      final response = await OnemapApiService.dio.get(
        '/common/elastic/search',
        options: Options(
          headers: {
            "Authorization": await ref
                .read(appDataProvider.notifier)
                .getOnemapAccessToken(),
          },
        ),
        queryParameters: {
          'searchVal': searchValue,
          'returnGeom': 'Y',
          'getAddrDetails': 'Y',
        },
      );
      return (response.data["results"] as List)
          .map(
            (item) => OnemapSearchResult.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        if (kDebugMode) {
          print('Onemap search error: ${e.response?.statusCode}');
        }
      }

      return [];
    }
  }
}
