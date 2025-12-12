import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatamallApiService {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://datamall2.mytransport.sg/ltaodataservice/v3',
            connectTimeout: Duration(seconds: 5),
            receiveTimeout: Duration(seconds: 5),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              options.headers['AccountKey'] = dotenv.env['DATAMALL_API_KEY'];
              return handler.next(options);
            },
          ),
        );
}

class OnemapApiService {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://apiB.com',
            connectTimeout: Duration(seconds: 5),
            receiveTimeout: Duration(seconds: 5),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              options.headers['AccountKey'] = dotenv.env['ONEMAP_API_KEY'];
              return handler.next(options);
            },
          ),
        );
}

class TelegramApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.telegram.org/bot${dotenv.env['TELEGRAM_BOT_TOKEN']}',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );
}
