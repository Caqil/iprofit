// lib/features/profile/repositories/profile_repository.dart
import '../../../core/services/api_client.dart';
import '../../../models/user.dart';
import '../../../repositories/base_repository.dart';

class ProfileRepository extends BaseRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get user profile
  Future<User> getProfile() async {
    return safeApiCall(() async {
      final response = await _apiClient.getProfile();
      return User.fromJson(response['user']);
    });
  }

  /// Update user profile - returns updated User object
  Future<User> updateProfile(Map<String, dynamic> userData) async {
    return safeApiCall(() async {
      final response = await _apiClient.updateProfile(userData);
      return User.fromJson(response['user']);
    });
  }

  /// Change user password
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

  /// Toggle biometric authentication
  Future<User> toggleBiometric(bool enable) async {
    return safeApiCall(() async {
      final response = enable
          ? await _apiClient.enableBiometric()
          : await _apiClient.disableBiometric();
      return User.fromJson(response['user']);
    });
  }

  /// Enable biometric authentication
  Future<User> enableBiometric() async {
    return safeApiCall(() async {
      final response = await _apiClient.enableBiometric();
      return User.fromJson(response['user']);
    });
  }

  /// Disable biometric authentication
  Future<User> disableBiometric() async {
    return safeApiCall(() async {
      final response = await _apiClient.disableBiometric();
      return User.fromJson(response['user']);
    });
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    return safeApiCall(() async {
      await _apiClient.deleteAccount();
    });
  }

  /// Get KYC status - ADD THIS METHOD
  Future<Map<String, dynamic>> getKycStatus() async {
    return safeApiCall(() async {
      try {
        final response = await _apiClient.getKycStatus();
        return response;
      } catch (e) {
        // Return fallback if KYC endpoint is not available
        return <String, dynamic>{
          'status': 'pending',
          'documents': [],
          'last_updated': null,
        };
      }
    });
  }

  /// Get support tickets - ADD THIS METHOD
  Future<List<dynamic>> getSupportTickets() async {
    return safeApiCall(() async {
      try {
        final response = await _apiClient.getSupportTickets();
        return response['tickets'] as List<dynamic>? ?? [];
      } catch (e) {
        // Return empty list if support tickets endpoint is not available
        return <dynamic>[];
      }
    });
  }

  /// Get app information - ADD THIS METHOD
  Future<Map<String, dynamic>> getAppInfo() async {
    return safeApiCall(() async {
      try {
        final response = await _apiClient.getAppSettings();
        return {
          'version': response['app_version'] ?? 'v2.1.3',
          'build': response['build_number'] ?? '123',
          'last_updated': DateTime.now().toIso8601String(),
          'support_email': response['support_email'] ?? 'support@example.com',
          'privacy_policy_url': response['privacy_policy_url'],
          'terms_of_service_url': response['terms_of_service_url'],
        };
      } catch (e) {
        // Return fallback app info
        return <String, dynamic>{
          'version': 'v2.1.3',
          'build': '123',
          'last_updated': DateTime.now().toIso8601String(),
          'support_email': 'support@example.com',
          'privacy_policy_url': null,
          'terms_of_service_url': null,
        };
      }
    });
  }

  /// Submit KYC documents
  Future<Map<String, dynamic>> submitKyc(Map<String, dynamic> kycData) async {
    return safeApiCall(() async {
      final response = await _apiClient.submitKyc(kycData);
      return response;
    });
  }

  /// Create support ticket
  Future<Map<String, dynamic>> createSupportTicket(
    Map<String, dynamic> ticketData,
  ) async {
    return safeApiCall(() async {
      final response = await _apiClient.createSupportTicket(ticketData);
      return response;
    });
  }
}
