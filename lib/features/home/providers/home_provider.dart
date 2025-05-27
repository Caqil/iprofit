// lib/features/home/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/home_repository.dart';
import '../../../providers/global_providers.dart';
import '../../../models/transaction.dart';
import '../../../models/user.dart';

part 'home_provider.g.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(apiClient: ref.watch(apiClientProvider));
});

class ProfitData {
  final DateTime date;
  final double amount;

  ProfitData({required this.date, required this.amount});
}

@riverpod
class Home extends _$Home {
  @override
  Future<Map<String, dynamic>> build() async {
    final repository = ref.watch(homeRepositoryProvider);

    // Get user profile
    final User user = await repository.getUserProfile();

    // Get profit chart data
    final List<ProfitData> profitData = await repository.getProfitData();

    // Get recent transactions
    final List<Transaction> transactions = await repository
        .getRecentTransactions();

    return {
      'user': user,
      'profitData': profitData,
      'recentTransactions': transactions,
    };
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(homeRepositoryProvider);

      // Get user profile
      final User user = await repository.getUserProfile();

      // Get profit chart data
      final List<ProfitData> profitData = await repository.getProfitData();

      // Get recent transactions
      final List<Transaction> transactions = await repository
          .getRecentTransactions();

      state = AsyncValue.data({
        'user': user,
        'profitData': profitData,
        'recentTransactions': transactions,
      });
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
