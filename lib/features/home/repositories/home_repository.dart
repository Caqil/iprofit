// lib/features/home/repositories/home_repository.dart
import 'package:app/core/services/api_client.dart';
import '../../../models/user.dart';
import '../../../models/transaction.dart';
import '../../../models/task.dart';
import '../../../models/referral.dart';
import '../../../repositories/base_repository.dart';
import '../providers/cached_home_provider.dart';

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
      // Get transactions and calculate daily profit data
      final response = await _apiClient.getTransactions();
      final List<dynamic> transactionData = response['transactions'];

      final transactions = transactionData
          .map((json) => Transaction.fromJson(json))
          .toList();

      // Group transactions by date and calculate daily profits
      final Map<String, double> dailyProfits = {};

      for (final transaction in transactions) {
        // Only include profit-generating transactions
        if (_isProfitTransaction(transaction)) {
          final date = DateTime.parse(transaction.createdAt);
          final dateKey =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          dailyProfits[dateKey] =
              (dailyProfits[dateKey] ?? 0) + transaction.amount;
        }
      }

      // Convert to ProfitData list for last 30 days
      final List<ProfitData> profitDataList = [];
      final now = DateTime.now();

      for (int i = 29; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final amount = dailyProfits[dateKey] ?? 0.0;

        profitDataList.add(ProfitData(date: date, amount: amount));
      }

      return profitDataList;
    });
  }

  Future<List<Transaction>> getRecentTransactions() async {
    return safeApiCall(() async {
      final response = await _apiClient.getTransactions();

      final List<dynamic> transactionData = response['transactions'];
      final transactions = transactionData
          .map((json) => Transaction.fromJson(json))
          .toList();

      // Sort by date (newest first) and take first 10
      transactions.sort(
        (a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
      );

      return transactions.take(10).toList();
    });
  }

  Future<List<ReferralLeaderboardItem>> getReferralLeaderboard() async {
    return safeApiCall(() async {
      // Get current user referrals
      final referralsResponse = await _apiClient.getReferrals();
      final earningsResponse = await _apiClient.getReferralEarnings();

      final List<dynamic> referralData = referralsResponse['referrals'];
      final referrals = referralData
          .map((json) => Referral.fromJson(json))
          .toList();

      // Get user profile for current user info
      final userResponse = await _apiClient.getProfile();
      final currentUser = User.fromJson(userResponse['user']);

      // Create leaderboard items
      final List<ReferralLeaderboardItem> leaderboard = [];

      // Add current user
      final currentUserEarnings = earningsResponse['total_earnings'] ?? 0.0;
      leaderboard.add(
        ReferralLeaderboardItem(
          name: 'You (${currentUser.name})',
          avatar: currentUser.name.isNotEmpty
              ? currentUser.name.substring(0, 2).toUpperCase()
              : 'U',
          referralCount: referrals.length,
          earnings: currentUserEarnings.toDouble(),
          isCurrentUser: true,
        ),
      );

      // Note: In a real app, you'd need an API endpoint to get other users' referral stats
      // For now, we'll just show the current user's data
      return leaderboard;
    });
  }

  Future<List<TaskProgress>> getTasksProgress() async {
    return safeApiCall(() async {
      final response = await _apiClient.getTasks();

      final List<dynamic> taskData = response['tasks'];
      final tasks = taskData.map((json) => Task.fromJson(json)).toList();

      return tasks
          .map(
            (task) => TaskProgress(
              title: task.name,
              isCompleted: task.isCompleted,
              status: task.isCompleted ? 'Completed' : 'Pending',
              taskType: task.taskType,
              isMandatory: task.isMandatory,
            ),
          )
          .toList();
    });
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    return safeApiCall(() async {
      // Get various stats for dashboard
      final user = await getUserProfile();
      final transactions = await getRecentTransactions();
      final referrals = await _apiClient.getReferrals();
      final earnings = await _apiClient.getReferralEarnings();

      // Calculate today's profit
      final today = DateTime.now();
      final todaysTransactions = transactions.where((t) {
        final transactionDate = DateTime.parse(t.createdAt);
        return transactionDate.year == today.year &&
            transactionDate.month == today.month &&
            transactionDate.day == today.day &&
            _isProfitTransaction(t);
      }).toList();

      final todaysProfit = todaysTransactions.fold(
        0.0,
        (sum, t) => sum + t.amount,
      );

      return {
        'total_balance': user.balance,
        'todays_profit': todaysProfit,
        'total_referrals': (referrals['referrals'] as List).length,
        'total_earnings': earnings['total_earnings'] ?? 0.0,
      };
    });
  }

  bool _isProfitTransaction(Transaction transaction) {
    return [
      'bonus',
      'referralBonus',
      'referralProfit',
      'deposit', // If deposits count as profit in your system
    ].contains(transaction.type.toString().split('.').last);
  }
}
