// lib/features/wallet/repositories/withdrawal_repository.dart
import 'package:app/core/services/api_client.dart';
import 'package:app/models/withdrawal.dart';
import 'package:app/repositories/base_repository.dart';

class WithdrawalRepository extends BaseRepository {
  final ApiClient _apiClient;

  WithdrawalRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Withdrawal>> getWithdrawals({int? limit, int? offset}) async {
    return safeApiCall(() async {
      final response = await _apiClient.getWithdrawals();

      final List<dynamic> withdrawalData = response['withdrawals'];
      return withdrawalData.map((json) => Withdrawal.fromJson(json)).toList();
    });
  }

  Future<Withdrawal> getWithdrawalById(int id) async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/user/withdrawals/$id');
      return Withdrawal.fromJson(response['withdrawal']);
    });
  }

  Future<Map<String, dynamic>> requestWithdrawal(
    Map<String, dynamic> data,
  ) async {
    return safeApiCall(() async {
      return await _apiClient.requestWithdrawal(data);
    });
  }
}
