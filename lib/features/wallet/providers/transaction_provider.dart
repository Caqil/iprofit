// lib/features/wallet/providers/transaction_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/transaction_repository.dart';
import '../../../models/transaction.dart';
import '../../../providers/global_providers.dart';

part 'transaction_provider.g.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build({int limit = 20, int offset = 0}) async {
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getTransactions(limit: limit, offset: offset);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class TransactionDetail extends _$TransactionDetail {
  @override
  Future<Transaction> build(int id) async {
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getTransactionById(id);
  }
}
