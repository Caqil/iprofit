// lib/features/wallet/providers/withdrawal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/withdrawal_repository.dart';
import '../../../models/withdrawal.dart';
import '../../../providers/global_providers.dart';

part 'withdrawal_provider.g.dart';

final withdrawalRepositoryProvider = Provider<WithdrawalRepository>((ref) {
  return WithdrawalRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class WithdrawalList extends _$WithdrawalList {
  @override
  Future<List<Withdrawal>> build({int limit = 20, int offset = 0}) async {
    final repository = ref.watch(withdrawalRepositoryProvider);
    return repository.getWithdrawals(limit: limit, offset: offset);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class WithdrawalDetail extends _$WithdrawalDetail {
  @override
  Future<Withdrawal> build(int id) async {
    final repository = ref.watch(withdrawalRepositoryProvider);
    return repository.getWithdrawalById(id);
  }
}

@riverpod
class WithdrawalRequest extends _$WithdrawalRequest {
  @override
  Future<void> build() async {
    return Future.value();
  }

  Future<Map<String, dynamic>> requestWithdrawal({
    required double amount,
    required String paymentMethod,
    required Map<String, dynamic> paymentDetails,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(withdrawalRepositoryProvider);

      final result = await repository.requestWithdrawal({
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_details': paymentDetails,
      });

      state = const AsyncData(null);

      // Corrected: Use invalidate instead of direct notifier access
      ref.invalidate(withdrawalListProvider);

      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
