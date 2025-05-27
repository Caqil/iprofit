
import 'package:app/core/services/api_client.dart';

import '../../../models/plan.dart';
import '../../../repositories/base_repository.dart';

class PlansRepository extends BaseRepository {
  final ApiClient _apiClient;

  PlansRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Plan>> getPlans() async {
    return safeApiCall(() async {
      final response = await _apiClient.getPlans();
      final plans = (response['plans'] as List)
          .map((json) => Plan.fromJson(json))
          .toList();
      return plans;
    });
  }

  Future<Map<String, dynamic>> purchasePlan(int planId) async {
    return safeApiCall(() async {
      final response = await _apiClient.purchasePlan(planId);
      return response;
    });
  }
}
