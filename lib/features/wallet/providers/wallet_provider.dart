// lib/features/wallet/providers/wallet_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/wallet_repository.dart';
import '../../../models/transaction.dart';
import '../../../providers/global_providers.dart';

part 'wallet_provider.g.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class Transactions extends _$Transactions {
  @override
  Future<List<Transaction>> build() async {
    return ref.watch(walletRepositoryProvider).getTransactions();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final transactions = await ref
          .read(walletRepositoryProvider)
          .getTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
class Deposit extends _$Deposit {
  @override
  Future<void> build() async {}

  Future<Map<String, dynamic>> depositViaCoingate(double amount) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(walletRepositoryProvider)
          .depositViaCoingate(amount);
      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> depositViaUddoktapay(double amount) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(walletRepositoryProvider)
          .depositViaUddoktapay(amount);
      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> depositViaManual(
    double amount,
    String transactionId,
    String paymentMethod,
    Map<String, dynamic> senderInfo,
  ) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(walletRepositoryProvider)
          .depositViaManual(amount, transactionId, paymentMethod, senderInfo);
      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

@riverpod
class Withdrawal extends _$Withdrawal {
  @override
  Future<void> build() async {}

  Future<Map<String, dynamic>> requestWithdrawal(
    double amount,
    String paymentMethod,
    Map<String, dynamic> paymentDetails,
  ) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(walletRepositoryProvider)
          .requestWithdrawal(amount, paymentMethod, paymentDetails);
      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
