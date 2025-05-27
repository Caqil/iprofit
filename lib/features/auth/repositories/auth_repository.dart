// lib/features/auth/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/exceptions/auth_exception.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../models/user.dart';
import '../../../repositories/base_repository.dart';

class AuthRepository extends BaseRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({
    required ApiClient apiClient,
    required FlutterSecureStorage secureStorage,
  }) : _apiClient = apiClient,
       _secureStorage = secureStorage;

  // Login user
  Future<User> login(String email, String password, String deviceId) async {
    return safeApiCall(() async {
      try {
        final response = await _apiClient.login({
          'email': email,
          'password': password,
          'device_id': deviceId,
        });

        if (response.containsKey('token') && response.containsKey('user')) {
          // Save token to secure storage
          await _secureStorage.write(
            key: StorageKeys.token,
            value: response['token'],
          );
          await _secureStorage.write(
            key: StorageKeys.deviceId,
            value: deviceId,
          );

          // Parse and return user
          return User.fromJson(response['user']);
        } else {
          throw AuthException(message: 'Invalid response from server');
        }
      } on DioException catch (e) {
        // Handle common auth errors
        if (e.response?.statusCode == 401) {
          throw AuthException(message: 'Invalid email or password');
        } else if (e.response?.statusCode == 403) {
          throw AuthException(message: 'Account is blocked or inactive');
        } else {
          throw ApiException(
            message: e.response?.data?['message'] ?? 'Login failed',
            statusCode: e.response?.statusCode ?? 500,
          );
        }
      } catch (e) {
        throw AuthException(message: e.toString());
      }
    });
  }

  // Register user
  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String deviceId,
    String? referCode,
  ) async {
    return safeApiCall(() async {
      try {
        await _apiClient.register({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'device_id': deviceId,
          if (referCode != null && referCode.isNotEmpty)
            'refer_code': referCode,
        });
      } on DioException catch (e) {
        if (e.response?.statusCode == 422) {
          // Validation errors
          final errors = e.response?.data?['errors'];
          if (errors is Map) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              throw AuthException(message: firstError.first.toString());
            }
          }
          throw AuthException(
            message:
                e.response?.data?['message'] ??
                'Registration failed: invalid data',
          );
        } else {
          throw ApiException(
            message: e.response?.data?['message'] ?? 'Registration failed',
            statusCode: e.response?.statusCode ?? 500,
          );
        }
      } catch (e) {
        throw AuthException(message: e.toString());
      }
    });
  }

  // Verify email
  Future<void> verifyEmail(String email, String code) async {
    return safeApiCall(() async {
      try {
        await _apiClient.verifyEmail({'email': email, 'code': code});
      } on DioException catch (e) {
        if (e.response?.statusCode == 422) {
          throw AuthException(message: 'Invalid verification code');
        } else {
          throw ApiException(
            message:
                e.response?.data?['message'] ?? 'Email verification failed',
            statusCode: e.response?.statusCode ?? 500,
          );
        }
      } catch (e) {
        throw AuthException(message: e.toString());
      }
    });
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    return safeApiCall(() async {
      try {
        await _apiClient.forgotPassword({'email': email});
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          throw AuthException(message: 'Email not found');
        } else {
          throw ApiException(
            message: e.response?.data?['message'] ?? 'Password reset failed',
            statusCode: e.response?.statusCode ?? 500,
          );
        }
      } catch (e) {
        throw AuthException(message: e.toString());
      }
    });
  }

  // Reset password
  Future<void> resetPassword(
    String email,
    String token,
    String newPassword,
  ) async {
    return safeApiCall(() async {
      try {
        await _apiClient.post(ApiConstants.resetPassword, {
          'email': email,
          'token': token,
          'new_password': newPassword,
        });
      } on DioException catch (e) {
        if (e.response?.statusCode == 422) {
          throw AuthException(message: 'Invalid reset token');
        } else {
          throw ApiException(
            message: e.response?.data?['message'] ?? 'Password reset failed',
            statusCode: e.response?.statusCode ?? 500,
          );
        }
      } catch (e) {
        throw AuthException(message: e.toString());
      }
    });
  }

  // Logout user
  Future<void> logout() async {
    try {
      // Call logout API if available
      await _apiClient.post('auth/logout', {}).catchError((_) {
        // Ignore API errors during logout
      });
    } finally {
      // Clear local storage regardless of API call success
      await _secureStorage.delete(key: StorageKeys.token);
      await _secureStorage.delete(key: StorageKeys.user);
      // Keep device ID as it should persist across sessions
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: StorageKeys.token);
    return token != null && token.isNotEmpty;
  }

  // Get the stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: StorageKeys.token);
  }

  // Get the stored device ID
  Future<String?> getDeviceId() async {
    return await _secureStorage.read(key: StorageKeys.deviceId);
  }
}
