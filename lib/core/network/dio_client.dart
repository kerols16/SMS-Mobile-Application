import 'package:dio/dio.dart';
import 'package:school_test/core/constants/api_constants.dart';
import 'package:school_test/core/storage/local_srotage.dart';


class DioClient {
  static Dio getInstance() {
    final dio = Dio(BaseOptions(
      baseUrl:        ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Accept':       'application/json',
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}