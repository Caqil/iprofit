// lib/features/wallet/repositories/wallet_repository.dart
import 'package:app/core/services/api_client.dart';
import '../../../models/transaction.dart';
import '../../../repositories/base_repository.dart';

class WalletRepository extends BaseRepository {
  final ApiClient _apiClient;

  WalletRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Transaction>> getTransactions() async {
    return safeApiCall(() async {
      final response = await _apiClient.getTransactions();
      final transactions = (response['transactions'] as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
      return transactions;
    });
  }

  Future<Map<String, dynamic>> depositViaCoingate(double amount) async {
    return safeApiCall(() async {
      final response = await _apiClient.depositViaCoingate({'amount': amount});
      return response;
    });
  }

  Future<Map<String, dynamic>> depositViaUddoktapay(double amount) async {
    return safeApiCall(() async {
      final response = await _apiClient.depositViaUddoktapay({
        'amount': amount,
      });
      return response;
    });
  }

  Future<Map<String, dynamic>> depositViaManual(
    double amount,
    String transactionId,
    String paymentMethod,
    Map<String, dynamic> senderInfo,
  ) async {
    return safeApiCall(() async {
      final response = await _apiClient.depositViaManual({
        'amount': amount,
        'transaction_id': transactionId,
        'payment_method': paymentMethod,
        'sender_information': senderInfo,
      });
      return response;
    });
  }

  Future<Map<String, dynamic>> requestWithdrawal(
    double amount,
    String paymentMethod,
    Map<String, dynamic> paymentDetails,
  ) async {
    return safeApiCall(() async {
      final response = await _apiClient.requestWithdrawal({
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_details': paymentDetails,
      });
      return response;
    });
  }
}
