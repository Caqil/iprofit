// lib/features/wallet/repositories/deposit_repository.dart
import 'package:app/core/services/api_client.dart';
import 'package:app/models/payment.dart';
import 'package:app/repositories/base_repository.dart';

class DepositRepository extends BaseRepository {
  final ApiClient _apiClient;

  DepositRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Map<String, dynamic>> depositViaCoingate(double amount) async {
    return safeApiCall(() async {
      return await _apiClient.depositViaCoingate({'amount': amount});
    });
  }

  Future<Map<String, dynamic>> depositViaUddoktapay(double amount) async {
    return safeApiCall(() async {
      return await _apiClient.depositViaUddoktapay({'amount': amount});
    });
  }

  Future<Map<String, dynamic>> depositViaManual(
    double amount,
    String transactionId,
    String paymentMethod,
    Map<String, dynamic> senderInformation,
  ) async {
    return safeApiCall(() async {
      return await _apiClient.depositViaManual({
        'amount': amount,
        'transaction_id': transactionId,
        'payment_method': paymentMethod,
        'sender_information': senderInformation,
      });
    });
  }

  Future<List<Payment>> getRecentDeposits({int limit = 5}) async {
    return safeApiCall(() async {
      final response = await _apiClient.get(
        '/user/deposits',
        queryParams: {'limit': limit},
      );

      final List<dynamic> depositData = response['deposits'];
      return depositData.map((json) => Payment.fromJson(json)).toList();
    });
  }
}
