// lib/features/wallet/repositories/transaction_repository.dart
import 'package:app/core/services/api_client.dart';
import 'package:app/models/transaction.dart';
import 'package:app/repositories/base_repository.dart';

class TransactionRepository extends BaseRepository {
  final ApiClient _apiClient;

  TransactionRepository({required ApiClient apiClient})
    : _apiClient = apiClient;

  Future<List<Transaction>> getTransactions({int? limit, int? offset}) async {
    return safeApiCall(() async {
      final response = await _apiClient.getTransactions(
        limit: limit,
        offset: offset,
      );

      final List<dynamic> transactionData = response['transactions'];
      return transactionData.map((json) => Transaction.fromJson(json)).toList();
    });
  }

  Future<Transaction> getTransactionById(int id) async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/user/transactions/$id');
      return Transaction.fromJson(response['transaction']);
    });
  }
}
