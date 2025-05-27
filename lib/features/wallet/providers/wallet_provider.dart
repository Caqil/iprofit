// lib/features/wallet/providers/wallet_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/wallet_repository.dart';
import '../../../providers/global_providers.dart';
import '../../../models/transaction.dart';
import '../../../models/user.dart';
import '../../../models/withdrawal.dart';
import '../../../core/enums/transaction_type.dart';

part 'wallet_provider.g.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(apiClient: ref.watch(apiClientProvider));
});

// Filter enum for transactions
enum TransactionFilter { all, deposit, withdraw, bonus }

// Filter state provider
final transactionFilterProvider = StateProvider<TransactionFilter>((ref) {
  return TransactionFilter.all;
});

@riverpod
class Wallet extends _$Wallet {
  @override
  Future<Map<String, dynamic>> build() async {
    final repository = ref.watch(walletRepositoryProvider);

    try {
      // Fetch all wallet data concurrently
      final results = await Future.wait([
        repository.getUserProfile(),
        repository.getTransactions(),
        repository.getWithdrawals(),
      ]);

      final user = results[0] as User;
      final transactions = results[1] as List<Transaction>;
      final withdrawals = results[2] as List<Withdrawal>;

      return {
        'user': user,
        'transactions': transactions,
        'withdrawals': withdrawals,
        'balance': user.balance,
      };
    } catch (e) {
      print('Error loading wallet data: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(walletRepositoryProvider);

      final results = await Future.wait([
        repository.getUserProfile(),
        repository.getTransactions(),
        repository.getWithdrawals(),
      ]);

      final user = results[0] as User;
      final transactions = results[1] as List<Transaction>;
      final withdrawals = results[2] as List<Withdrawal>;

      state = AsyncValue.data({
        'user': user,
        'transactions': transactions,
        'withdrawals': withdrawals,
        'balance': user.balance,
      });
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Get filtered transactions
  List<Transaction> getFilteredTransactions(TransactionFilter filter) {
    final data = state.valueOrNull;
    if (data == null) return [];

    final transactions = data['transactions'] as List<Transaction>;

    switch (filter) {
      case TransactionFilter.all:
        return transactions;
      case TransactionFilter.deposit:
        return transactions
            .where((t) => t.type == TransactionType.deposit)
            .toList();
      case TransactionFilter.withdraw:
        return transactions
            .where((t) => t.type == TransactionType.withdrawal)
            .toList();
      case TransactionFilter.bonus:
        return transactions
            .where(
              (t) =>
                  t.type == TransactionType.bonus ||
                  t.type == TransactionType.referralBonus ||
                  t.type == TransactionType.referralProfit,
            )
            .toList();
    }
  }

  // Apply coupon
  Future<bool> applyCoupon(String couponCode) async {
    try {
      final repository = ref.read(walletRepositoryProvider);
      await repository.applyCoupon(couponCode);

      // Refresh wallet data after applying coupon
      await refresh();
      return true;
    } catch (e) {
      print('Error applying coupon: $e');
      return false;
    }
  }

  // Get wallet performance data (last 7 days)
  Map<String, double> getWalletPerformance() {
    final data = state.valueOrNull;
    if (data == null) return {};

    final transactions = data['transactions'] as List<Transaction>;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final recentTransactions = transactions.where((t) {
      final transactionDate = DateTime.parse(t.createdAt);
      return transactionDate.isAfter(sevenDaysAgo);
    }).toList();

    double totalIncome = 0;
    double totalOutcome = 0;

    for (final transaction in recentTransactions) {
      if (_isIncomeTransaction(transaction)) {
        totalIncome += transaction.amount;
      } else {
        totalOutcome += transaction.amount;
      }
    }

    return {
      'income': totalIncome,
      'outcome': totalOutcome,
      'net': totalIncome - totalOutcome,
    };
  }

  bool _isIncomeTransaction(Transaction transaction) {
    return [
      TransactionType.deposit,
      TransactionType.bonus,
      TransactionType.referralBonus,
      TransactionType.referralProfit,
    ].contains(transaction.type);
  }
}
