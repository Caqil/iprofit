// lib/features/auth/repositories/auth_repository.dart
import 'package:app/core/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/dio_client.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../models/user.dart';
import '../../../repositories/base_repository.dart';

class AuthRepository extends BaseRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({ApiClient? apiClient, FlutterSecureStorage? secureStorage})
    : _apiClient = apiClient ?? ApiClient(DioClient.getInstance()),
      _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<User> login(String email, String password, String deviceId) async {
    return safeApiCall(() async {
      final response = await _apiClient.login({
        'email': email,
        'password': password,
        'device_id': deviceId,
      });

      // Save token and user data
      await _secureStorage.write(
        key: StorageKeys.token,
        value: response['token'],
      );
      await _secureStorage.write(key: StorageKeys.deviceId, value: deviceId);

      return User.fromJson(response['user']);
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String deviceId,
    String? referCode,
  ) async {
    return safeApiCall(() async {
      await _apiClient.register({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'device_id': deviceId,
        if (referCode != null) 'refer_code': referCode,
      });
    });
  }

  Future<void> verifyEmail(String email, String code) async {
    return safeApiCall(() async {
      await _apiClient.verifyEmail({'email': email, 'code': code});
    });
  }

  Future<void> forgotPassword(String email) async {
    return safeApiCall(() async {
      await _apiClient.forgotPassword({'email': email});
    });
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: StorageKeys.token);
    await _secureStorage.delete(key: StorageKeys.user);
    // Don't delete device ID as it should persist across sessions
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: StorageKeys.token);
    return token != null;
  }
}
