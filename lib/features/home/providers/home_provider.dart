// lib/features/home/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/home_repository.dart';
import '../../../providers/global_providers.dart';
import '../../../models/transaction.dart';
import '../../../models/user.dart';
import '../../../core/enums/task_type.dart';

part 'home_provider.g.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(apiClient: ref.watch(apiClientProvider));
});

class ProfitData {
  final DateTime date;
  final double amount;

  ProfitData({required this.date, required this.amount});
}

class ReferralLeaderboardItem {
  final String name;
  final String avatar;
  final int referralCount;
  final double earnings;
  final bool isCurrentUser;

  ReferralLeaderboardItem({
    required this.name,
    required this.avatar,
    required this.referralCount,
    required this.earnings,
    this.isCurrentUser = false,
  });
}

class TaskProgress {
  final String title;
  final bool isCompleted;
  final String status;
  final TaskType taskType;
  final bool isMandatory;

  TaskProgress({
    required this.title,
    required this.isCompleted,
    required this.status,
    required this.taskType,
    required this.isMandatory,
  });
}

@riverpod
class Home extends _$Home {
  @override
  Future<Map<String, dynamic>> build() async {
    final repository = ref.watch(homeRepositoryProvider);

    try {
      // Fetch all data concurrently for better performance
      final results = await Future.wait([
        repository.getUserProfile(),
        repository.getProfitData(),
        repository.getRecentTransactions(),
        repository.getReferralLeaderboard(),
        repository.getTasksProgress(),
        repository.getDashboardStats(),
      ]);

      return {
        'user': results[0] as User,
        'profitData': results[1] as List<ProfitData>,
        'recentTransactions': results[2] as List<Transaction>,
        'referralLeaderboard': results[3] as List<ReferralLeaderboardItem>,
        'tasksProgress': results[4] as List<TaskProgress>,
        'dashboardStats': results[5] as Map<String, dynamic>,
      };
    } catch (e) {
      // Log error and rethrow
      print('Error loading home data: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(homeRepositoryProvider);

      // Fetch all data concurrently for better performance
      final results = await Future.wait([
        repository.getUserProfile(),
        repository.getProfitData(),
        repository.getRecentTransactions(),
        repository.getReferralLeaderboard(),
        repository.getTasksProgress(),
        repository.getDashboardStats(),
      ]);

      state = AsyncValue.data({
        'user': results[0] as User,
        'profitData': results[1] as List<ProfitData>,
        'recentTransactions': results[2] as List<Transaction>,
        'referralLeaderboard': results[3] as List<ReferralLeaderboardItem>,
        'tasksProgress': results[4] as List<TaskProgress>,
        'dashboardStats': results[5] as Map<String, dynamic>,
      });
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Get today's profit from dashboard stats
  double getTodaysProfit() {
    final data = state.valueOrNull;
    if (data == null) return 0.0;

    final dashboardStats = data['dashboardStats'] as Map<String, dynamic>?;
    return dashboardStats?['todays_profit']?.toDouble() ?? 0.0;
  }

  // Get completed tasks count
  int getCompletedTasksCount() {
    final data = state.valueOrNull;
    if (data == null) return 0;

    final tasksProgress = data['tasksProgress'] as List<TaskProgress>?;
    return tasksProgress?.where((task) => task.isCompleted).length ?? 0;
  }

  // Get total tasks count
  int getTotalTasksCount() {
    final data = state.valueOrNull;
    if (data == null) return 0;

    final tasksProgress = data['tasksProgress'] as List<TaskProgress>?;
    return tasksProgress?.length ?? 0;
  }

  // Calculate profit percentage change
  double getProfitPercentageChange() {
    final data = state.valueOrNull;
    if (data == null) return 0.0;

    final profitData = data['profitData'] as List<ProfitData>?;
    if (profitData == null || profitData.length < 2) return 0.0;

    final latest = profitData.last.amount;
    final previous = profitData[profitData.length - 2].amount;

    if (previous == 0) return latest > 0 ? 100.0 : 0.0;
    return ((latest - previous) / previous) * 100;
  }
}
