// lib/features/wallet/repositories/wallet_repository.dart
import '../../../core/services/api_client.dart';
import '../../../models/user.dart';
import '../../../models/transaction.dart';
import '../../../models/withdrawal.dart';
import '../../../repositories/base_repository.dart';

class WalletRepository extends BaseRepository {
  final ApiClient _apiClient;

  WalletRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<User> getUserProfile() async {
    return safeApiCall(() async {
      final response = await _apiClient.getProfile();
      return User.fromJson(response['user']);
    });
  }

  Future<List<Transaction>> getTransactions() async {
    return safeApiCall(() async {
      final response = await _apiClient.getTransactions(limit: 50);
      final List<dynamic> transactionData = response['transactions'] ?? [];

      final transactions = transactionData
          .map((json) => Transaction.fromJson(json))
          .toList();

      // Sort by date (newest first)
      transactions.sort(
        (a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
      );

      return transactions;
    });
  }

  Future<List<Withdrawal>> getWithdrawals() async {
    return safeApiCall(() async {
      final response = await _apiClient.getWithdrawals();
      final List<dynamic> withdrawalData = response['withdrawals'] ?? [];

      return withdrawalData.map((json) => Withdrawal.fromJson(json)).toList();
    });
  }

  Future<Map<String, dynamic>> requestWithdrawal(
    Map<String, dynamic> withdrawalData,
  ) async {
    return safeApiCall(() async {
      return await _apiClient.requestWithdrawal(withdrawalData);
    });
  }

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
    Map<String, dynamic> depositData,
  ) async {
    return safeApiCall(() async {
      return await _apiClient.depositViaManual(depositData);
    });
  }

  Future<Map<String, dynamic>> applyCoupon(String couponCode) async {
    return safeApiCall(() async {
      // Note: This endpoint doesn't exist in your current API
      // You'll need to add it to your backend if you want coupon functionality
      return await _apiClient.post('/user/apply-coupon', {
        'coupon_code': couponCode,
      });
    });
  }

  Future<Map<String, dynamic>> getWalletStats() async {
    return safeApiCall(() async {
      // Calculate stats from transactions
      final transactions = await getTransactions();
      final user = await getUserProfile();

      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      final recentTransactions = transactions.where((t) {
        final transactionDate = DateTime.parse(t.createdAt);
        return transactionDate.isAfter(sevenDaysAgo);
      }).toList();

      double totalDeposits = 0;
      double totalWithdrawals = 0;
      double totalBonuses = 0;

      for (final transaction in recentTransactions) {
        switch (transaction.type.toString().split('.').last) {
          case 'deposit':
            totalDeposits += transaction.amount;
            break;
          case 'withdrawal':
            totalWithdrawals += transaction.amount;
            break;
          case 'bonus':
          case 'referralBonus':
          case 'referralProfit':
            totalBonuses += transaction.amount;
            break;
        }
      }

      return {
        'current_balance': user.balance,
        'total_deposits_7d': totalDeposits,
        'total_withdrawals_7d': totalWithdrawals,
        'total_bonuses_7d': totalBonuses,
        'transaction_count_7d': recentTransactions.length,
      };
    });
  }
}
