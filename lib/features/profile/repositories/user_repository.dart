
import 'package:app/core/services/api_client.dart';

import '../../../models/user.dart';
import '../../../repositories/base_repository.dart';

class UserRepository extends BaseRepository {
  final ApiClient _apiClient;

  UserRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<User> getProfile() async {
    return safeApiCall(() async {
      final response = await _apiClient.getProfile();
      return User.fromJson(response['user']);
    });
  }

  Future<User> updateProfile(Map<String, dynamic> userData) async {
    return safeApiCall(() async {
      final response = await _apiClient.updateProfile(userData);
      return User.fromJson(response['user']);
    });
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return safeApiCall(() async {
      await _apiClient.changePassword({
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    });
  }

  Future<void> toggleBiometric(bool enable) async {
    return safeApiCall(() async {
      if (enable) {
        await _apiClient.post('/user/enable-biometric', {});
      } else {
        await _apiClient.post('/user/disable-biometric', {});
      }
    });
  }

  Future<List<Map<String, dynamic>>> getDevices() async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/user/devices');
      return (response['devices'] as List).cast<Map<String, dynamic>>();
    });
  }

  Future<void> removeDevice(String deviceId) async {
    return safeApiCall(() async {
      await _apiClient.delete('/user/devices/$deviceId');
    });
  }

  Future<User> updateProfilePicture(String imageUrl) async {
    return safeApiCall(() async {
      final response = await _apiClient.updateProfile({
        'profile_pic_url': imageUrl,
      });
      return User.fromJson(response['user']);
    });
  }

  Future<Map<String, dynamic>> getAccountStatistics() async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/user/statistics');
      return response;
    });
  }

  Future<bool> checkEmailExists(String email) async {
    return safeApiCall(() async {
      final response = await _apiClient.post('/auth/check-email', {
        'email': email,
      });
      return response['exists'] as bool;
    });
  }

  Future<bool> checkPhoneExists(String phone) async {
    return safeApiCall(() async {
      final response = await _apiClient.post('/auth/check-phone', {
        'phone': phone,
      });
      return response['exists'] as bool;
    });
  }

  Future<void> updateNotificationSettings(Map<String, bool> settings) async {
    return safeApiCall(() async {
      await _apiClient.put('/user/notification-settings', settings);
    });
  }

  Future<Map<String, bool>> getNotificationSettings() async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/user/notification-settings');
      return (response['settings'] as Map<String, dynamic>)
          .cast<String, bool>();
    });
  }

  Future<void> logoutFromAllDevices() async {
    return safeApiCall(() async {
      await _apiClient.post('/auth/logout-all', {});
    });
  }

  Future<void> deactivateAccount(String password) async {
    return safeApiCall(() async {
      await _apiClient.post('/user/deactivate', {'password': password});
    });
  }
}
