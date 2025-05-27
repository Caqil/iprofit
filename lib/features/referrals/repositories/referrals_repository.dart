
import 'package:app/core/services/api_service.dart';

import '../../../models/referral.dart';
import '../../../repositories/base_repository.dart';

class ReferralsRepository extends BaseRepository {
  final ApiClient _apiClient;

  ReferralsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Map<String, dynamic>> getReferrals() async {
    return safeApiCall(() async {
      final response = await _apiClient.getReferrals();
      return response;
    });
  }

  Future<Map<String, dynamic>> getReferralEarnings() async {
    return safeApiCall(() async {
      final response = await _apiClient.getReferralEarnings();
      return response;
    });
  }
}
