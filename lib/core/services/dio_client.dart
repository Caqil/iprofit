// lib/core/services/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../constants/storage_keys.dart';

class DioClient {
  static final Logger _logger = Logger();
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Dio getInstance() {
    final Dio dio = Dio();

    // Add logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => _logger.d(object),
      ),
    );

    // Add auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: StorageKeys.token);
          final deviceId = await _secureStorage.read(key: StorageKeys.deviceId);

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (deviceId != null) {
            options.headers['X-Device-ID'] = deviceId;
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle token expiration or authentication errors
            // You can add a listener to notify the app to log out the user
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
