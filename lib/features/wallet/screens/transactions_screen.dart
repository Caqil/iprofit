import 'package:app/core/utils/formatters.dart';
import 'package:app/features/wallet/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionListProvider());

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactionsState.when(
        data: (transactions) {
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text('${transaction.type} - ${transaction.amount}'),
                subtitle: Text(
                  Formatters.formatDateTime(transaction.createdAt),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}
