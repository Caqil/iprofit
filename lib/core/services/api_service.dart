// lib/core/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';
import 'api_client.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  late final ApiClient _apiClient;

  ApiService({required Dio dio, required FlutterSecureStorage secureStorage})
    : _dio = dio,
      _secureStorage = secureStorage {
    _setupInterceptors();
    _apiClient = ApiClient(_dio);
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
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
  }

  // Forward methods to the API client

  // Auth methods
  Future<Map<String, dynamic>> login(Map<String, dynamic> body) {
    return _apiClient.login(body);
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) {
    return _apiClient.register(body);
  }

  Future<Map<String, dynamic>> verifyEmail(Map<String, dynamic> body) {
    return _apiClient.verifyEmail(body);
  }

  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> body) {
    return _apiClient.forgotPassword(body);
  }

  // User methods
  Future<Map<String, dynamic>> getProfile() {
    return _apiClient.getProfile();
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) {
    return _apiClient.updateProfile(body);
  }

  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> body) {
    return _apiClient.changePassword(body);
  }

  // Plan methods
  Future<Map<String, dynamic>> getPlans() {
    return _apiClient.getPlans();
  }

  Future<Map<String, dynamic>> purchasePlan(int id) {
    return _apiClient.purchasePlan(id);
  }

  // Generic methods
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) {
    return _apiClient.get(path, queryParams: queryParams);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) {
    return _apiClient.post(path, body);
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) {
    return _apiClient.put(path, body);
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) {
    return _apiClient.patch(path, body);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _apiClient.delete(path, body: body);
  }
}
