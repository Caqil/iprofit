
// lib/features/wallet/providers/deposit_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/deposit_repository.dart';
import '../../../models/payment.dart';
import '../../../providers/global_providers.dart';

part 'deposit_provider.g.dart';

final depositRepositoryProvider = Provider<DepositRepository>((ref) {
  return DepositRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class RecentDeposits extends _$RecentDeposits {
  @override
  Future<List<Payment>> build({int limit = 5}) async {
    final repository = ref.watch(depositRepositoryProvider);
    return repository.getRecentDeposits(limit: limit);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class CoinGateDeposit extends _$CoinGateDeposit {
  @override
  Future<void> build() async {
    return Future.value();
  }

  Future<Map<String, dynamic>> deposit(double amount) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(depositRepositoryProvider);
      final result = await repository.depositViaCoingate(amount);
      
      state = const AsyncData(null);
      
      // Corrected: Proper family provider notifier access
      ref.invalidate(recentDepositsProvider); // This invalidates all instances
      
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

@riverpod
class UddoktapayDeposit extends _$UddoktapayDeposit {
  @override
  Future<void> build() async {
    return Future.value();
  }

  Future<Map<String, dynamic>> deposit(double amount) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(depositRepositoryProvider);
      final result = await repository.depositViaUddoktapay(amount);
      
      state = const AsyncData(null);
      
      // Corrected: Use invalidate instead of directly accessing notifier
      ref.invalidate(recentDepositsProvider);
      
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

@riverpod
class ManualDeposit extends _$ManualDeposit {
  @override
  Future<void> build() async {
    return Future.value();
  }

  Future<Map<String, dynamic>> deposit({
    required double amount,
    required String transactionId,
    required String paymentMethod,
    required Map<String, dynamic> senderInformation,
  }) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(depositRepositoryProvider);
      final result = await repository.depositViaManual(
        amount,
        transactionId,
        paymentMethod,
        senderInformation,
      );
      
      state = const AsyncData(null);
      
      // Corrected: Use invalidate instead of directly accessing notifier
      ref.invalidate(recentDepositsProvider);
      
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}