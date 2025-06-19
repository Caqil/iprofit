// lib/features/home/providers/cached_home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/home_repository.dart';
import '../../../providers/global_providers.dart';
import '../../../models/transaction.dart';
import '../../../models/user.dart';
import '../../../core/enums/task_type.dart';
import '../../../core/services/cache_service.dart';

part 'cached_home_provider.g.dart';

// Cache service provider
final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

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

// Create a synchronous provider for cached data
final syncCachedHomeProvider = Provider<Map<String, dynamic>?>((ref) {
  final cacheService = ref.read(cacheServiceProvider);
  final cachedData = cacheService.getCachedHomeData();

  if (cachedData != null) {
    print('📱 Sync provider: Cached data available');
    // Trigger background refresh
    Future.microtask(() {
      ref.read(cachedHomeProvider.notifier).triggerBackgroundRefresh();
    });
    return cachedData;
  }

  print('📱 Sync provider: No cached data');
  return null;
});

@riverpod
class CachedHome extends _$CachedHome {
  @override
  Future<Map<String, dynamic>> build() async {
    return _initializeWithCache();
  }

  /// Initialize with cached data if available, otherwise load from API
  Future<Map<String, dynamic>> _initializeWithCache() async {
    final cacheService = ref.read(cacheServiceProvider);

    // Check for cached data first
    final cachedData = cacheService.getCachedHomeData();

    if (cachedData != null) {
      print('📱 Async provider: Cached data found');
      return cachedData;
    }

    // No cache - fetch from API (first time)
    print('🌐 Async provider: No cache - fetching from API');
    return await _fetchFromAPI();
  }

  /// Background refresh without changing loading state
  void _backgroundRefresh() {
    Future.delayed(Duration.zero, () async {
      try {
        print('🔄 Background refresh started');
        final freshData = await _fetchFromAPI();

        // Update state with fresh data
        state = AsyncData(freshData);
        print('✅ Background refresh completed');
      } catch (e) {
        print('❌ Background refresh failed: $e');
        // Don't change state on background refresh error
      }
    });
  }

  /// Public method for external background refresh calls
  void triggerBackgroundRefresh() {
    _backgroundRefresh();
  }

  /// Fetch data from API and cache it
  Future<Map<String, dynamic>> _fetchFromAPI() async {
    final repository = ref.read(homeRepositoryProvider);
    final cacheService = ref.read(cacheServiceProvider);

    try {
      // Fetch all data concurrently
      final results = await Future.wait([
        repository.getUserProfile(),
        repository.getProfitData(),
        repository.getRecentTransactions(),
        repository.getReferralLeaderboard(),
        repository.getTasksProgress(),
        repository.getDashboardStats(),
      ]);

      final homeData = {
        'user': results[0] as User,
        'profitData': results[1] as List<ProfitData>,
        'recentTransactions': results[2] as List<Transaction>,
        'referralLeaderboard': results[3] as List<ReferralLeaderboardItem>,
        'tasksProgress': results[4] as List<TaskProgress>,
        'dashboardStats': results[5] as Map<String, dynamic>,
      };

      // Cache the data for next time
      await cacheService.saveHomeData(homeData);
      print('✅ Home data fetched and cached');

      return homeData;
    } catch (e) {
      print('❌ Error fetching home data: $e');

      // If API fails, try to return cached data even if expired
      final cachedData = cacheService.getCachedHomeData();
      if (cachedData != null) {
        print('📱 API failed, using expired cache data');
        return cachedData;
      }

      rethrow;
    }
  }

  /// Refresh data from API (for pull-to-refresh)
  Future<void> refresh() async {
    print('🔄 Refreshing home data...');

    try {
      // Fetch fresh data from API
      final freshData = await _fetchFromAPI();

      // Update the state with fresh data
      state = AsyncData(freshData);
      print('✅ Home data refreshed successfully');
    } catch (e) {
      print('❌ Failed to refresh home data: $e');
      // Don't update state on error - keep existing data
      rethrow;
    }
  }

  /// Force reload from API (ignores cache)
  Future<void> forceReload() async {
    print('🔄 Force reloading home data...');
    state = const AsyncLoading();

    try {
      final freshData = await _fetchFromAPI();
      state = AsyncData(freshData);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Get current user from state or cache
  User? getCurrentUser() {
    final currentData = state.valueOrNull;
    if (currentData != null) {
      return currentData['user'] as User?;
    }

    // Fallback to cache
    final cacheService = ref.read(cacheServiceProvider);
    return cacheService.getCachedUserData();
  }

  /// Check if we have any data (cached or current)
  bool hasData() {
    // First check if current state has data
    if (state.valueOrNull != null) return true;

    // Then check if cache has data
    final cacheService = ref.read(cacheServiceProvider);
    return cacheService.getCachedHomeData() != null;
  }

  /// Get current cached data directly from cache (bypasses state)
  Map<String, dynamic>? getCachedData() {
    final cacheService = ref.read(cacheServiceProvider);
    return cacheService.getCachedHomeData();
  }

  /// Get cache info for debugging
  Map<String, dynamic> getCacheInfo() {
    final cacheService = ref.read(cacheServiceProvider);
    return cacheService.getCacheInfo();
  }

  /// Get today's profit amount
  double getTodaysProfit() {
    final currentData = state.valueOrNull;
    if (currentData == null) return 0.0;

    final profitData = currentData['profitData'] as List<ProfitData>?;
    if (profitData == null || profitData.isEmpty) return 0.0;

    // Get today's date
    final today = DateTime.now();

    // Find today's profit data
    final todaysProfit = profitData.firstWhere(
      (profit) =>
          profit.date.year == today.year &&
          profit.date.month == today.month &&
          profit.date.day == today.day,
      orElse: () => ProfitData(date: today, amount: 0.0),
    );

    return todaysProfit.amount;
  }

  /// Get profit percentage change (today vs yesterday)
  double getProfitPercentageChange() {
    final currentData = state.valueOrNull;
    if (currentData == null) return 0.0;

    final profitData = currentData['profitData'] as List<ProfitData>?;
    if (profitData == null || profitData.length < 2) return 0.0;

    // Get today's and yesterday's dates
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // Find today's and yesterday's profit
    final todaysProfit = profitData.firstWhere(
      (profit) =>
          profit.date.year == today.year &&
          profit.date.month == today.month &&
          profit.date.day == today.day,
      orElse: () => ProfitData(date: today, amount: 0.0),
    );

    final yesterdaysProfit = profitData.firstWhere(
      (profit) =>
          profit.date.year == yesterday.year &&
          profit.date.month == yesterday.month &&
          profit.date.day == yesterday.day,
      orElse: () => ProfitData(date: yesterday, amount: 0.0),
    );

    // Calculate percentage change
    if (yesterdaysProfit.amount == 0) {
      return todaysProfit.amount > 0 ? 100.0 : 0.0;
    }

    final change =
        ((todaysProfit.amount - yesterdaysProfit.amount) /
            yesterdaysProfit.amount) *
        100;
    return change;
  }

  /// Get total balance (current user balance)
  double getTotalBalance() {
    final currentData = state.valueOrNull;
    if (currentData == null) return 0.0;

    final user = currentData['user'] as User?;
    return user?.balance ?? 0.0;
  }

  /// Get recent transactions
  List<Transaction> getRecentTransactions({int limit = 5}) {
    final currentData = state.valueOrNull;
    if (currentData == null) return [];

    final transactions =
        currentData['recentTransactions'] as List<Transaction>?;
    if (transactions == null) return [];

    return transactions.take(limit).toList();
  }

  /// Get profit data for chart
  List<ProfitData> getProfitDataForChart({int days = 30}) {
    final currentData = state.valueOrNull;
    if (currentData == null) return [];

    final profitData = currentData['profitData'] as List<ProfitData>?;
    if (profitData == null) return [];

    return profitData.take(days).toList();
  }

  /// Get dashboard statistics
  Map<String, dynamic> getDashboardStats() {
    final currentData = state.valueOrNull;
    if (currentData == null) return {};

    return currentData['dashboardStats'] as Map<String, dynamic>? ?? {};
  }

  /// Get tasks progress
  List<TaskProgress> getTasksProgress() {
    final currentData = state.valueOrNull;
    if (currentData == null) return [];

    return currentData['tasksProgress'] as List<TaskProgress>? ?? [];
  }

  /// Get referral leaderboard
  List<ReferralLeaderboardItem> getReferralLeaderboard() {
    final currentData = state.valueOrNull;
    if (currentData == null) return [];

    return currentData['referralLeaderboard']
            as List<ReferralLeaderboardItem>? ??
        [];
  }

  /// Check if data is loading for the first time (no cache)
  bool isFirstTimeLoading() {
    return state.isLoading && !hasData();
  }

  /// Check if data is being refreshed (has cache but loading new data)
  bool isRefreshing() {
    return state.isLoading && hasData();
  }
}
