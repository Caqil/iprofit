// lib/features/home/repositories/home_repository.dart
import 'package:app/core/services/api_client.dart';

import '../../../models/user.dart';
import '../../../models/transaction.dart';
import '../../../repositories/base_repository.dart';
import '../providers/home_provider.dart';

class HomeRepository extends BaseRepository {
  final ApiClient _apiClient;

  HomeRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<User> getUserProfile() async {
    return safeApiCall(() async {
      final response = await _apiClient.getProfile();
      return User.fromJson(response['user']);
    });
  }

  Future<List<ProfitData>> getProfitData() async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/user/profit-chart');

      // Parse the profit data
      final List<dynamic> data = response['profit_data'];
      return data.map((item) {
        return ProfitData(
          date: DateTime.parse(item['date']),
          amount: item['amount'].toDouble(),
        );
      }).toList();
    });
  }

  Future<List<Transaction>> getRecentTransactions() async {
    return safeApiCall(() async {
      final response = await _apiClient.getTransactions();

      final List<dynamic> transactionData = response['transactions'];
      final transactions = transactionData
          .map((json) => Transaction.fromJson(json))
          .toList();

      // Sort by date (newest first) and take first 5
      transactions.sort(
        (a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
      );

      return transactions.take(5).toList();
    });
  }
}
