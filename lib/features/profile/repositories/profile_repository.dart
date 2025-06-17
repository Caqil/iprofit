// lib/features/profile/repositories/profile_repository.dart
import '../../../core/services/api_client.dart';
import '../../../models/user.dart';
import '../../../repositories/base_repository.dart';

class ProfileRepository extends BaseRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<User> getUserProfile() async {
    return safeApiCall(() async {
      final response = await _apiClient.getProfile();
      return User.fromJson(response['user']);
    });
  }

  Future<Map<String, dynamic>> getKycStatus() async {
    return safeApiCall(() async {
      final response = await _apiClient.getKycStatus();
      return response;
    });
  }

  Future<List<dynamic>> getSupportTickets() async {
    return safeApiCall(() async {
      final response = await _apiClient.getSupportTickets();
      return response['tickets'] ?? [];
    });
  }

  Future<Map<String, dynamic>> getAppInfo() async {
    return safeApiCall(() async {
      final response = await _apiClient.getAppSettings();
      return {
        'version': response['app_version'] ?? response['version'] ?? 'v2.1.3',
        'build': response['build_number'] ?? response['build'] ?? '123',
        'support_email': response['support_email'] ?? 'support@example.com',
        'privacy_policy_url': response['privacy_policy_url'] ?? '',
        'terms_of_service_url': response['terms_of_service_url'] ?? '',
      };
    });
  }

  Future<Map<String, dynamic>> getAccountSettings() async {
    return safeApiCall(() async {
      final user = await getUserProfile();
      return {
        'biometric_enabled': user.biometricEnabled,
        'notifications_enabled': true, // This could come from user preferences
        'two_factor_enabled': false, // This could be a separate field
      };
    });
  }

  Future<void> enableBiometric() async {
    return safeApiCall(() async {
      await _apiClient.enableBiometric();
    });
  }

  Future<void> disableBiometric() async {
    return safeApiCall(() async {
      await _apiClient.disableBiometric();
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

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    return safeApiCall(() async {
      await _apiClient.updateProfile(profileData);
    });
  }

  Future<void> deleteAccount() async {
    return safeApiCall(() async {
      await _apiClient.deleteAccount();
    });
  }

  Future<void> submitKyc(Map<String, dynamic> kycData) async {
    return safeApiCall(() async {
      await _apiClient.submitKyc(kycData);
    });
  }

  Future<void> createSupportTicket(String subject, String message) async {
    return safeApiCall(() async {
      await _apiClient.createSupportTicket({
        'subject': subject,
        'message': message,
      });
    });
  }
}
