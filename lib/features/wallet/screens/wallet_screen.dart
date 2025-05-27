// lib/features/wallet/screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/wallet_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../core/enums/transaction_type.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionsProvider);
    final authState = ref.watch(authProvider);

    final user = authState.valueOrNull;
    final balance = user?.balance ?? 0.0;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(transactionsProvider.notifier).refresh(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance card
              _buildBalanceCard(context, balance),
              const SizedBox(height: 24),

              // Quick actions
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // Recent transactions
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              transactionsState.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No transactions yet'),
                      ),
                    );
                  }

                  // Show only the first 5 transactions
                  final recentTransactions = transactions.take(5).toList();

                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = recentTransactions[index];
                          return _buildTransactionItem(context, transaction);
                        },
                      ),
                      if (transactions.length > 5)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextButton(
                            onPressed: () => context.push('/transactions'),
                            child: const Text('View All Transactions'),
                          ),
                        ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomErrorWidget(
                    error: error.toString(),
                    onRetry: () => ref.refresh(transactionsProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          context,
          Icons.add,
          'Deposit',
          () => context.push('/deposit'),
        ),
        _buildActionButton(
          context,
          Icons.arrow_outward,
          'Withdraw',
          () => context.push('/withdrawal'),
        ),
        _buildActionButton(
          context,
          Icons.history,
          'History',
          () => context.push('/transactions'),
        ),
        _buildActionButton(context, Icons.swap_horiz, 'Transfer', () {
          // TODO: Implement transfer functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transfer feature coming soon')),
          );
        }),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, transaction) {
    final IconData icon;
    final Color color;
    final String title;
    final String subtitle;

    // Determine icon and color based on transaction type
    switch (transaction.type) {
      case TransactionType.deposit:
        icon = Icons.add_circle;
        color = Colors.green;
        title = 'Deposit';
        subtitle = 'Via ${transaction.description ?? 'payment gateway'}';
        break;
      case TransactionType.withdrawal:
        icon = Icons.remove_circle;
        color = Colors.red;
        title = 'Withdrawal';
        subtitle = transaction.description ?? 'Withdrawal request';
        break;
      case TransactionType.bonus:
        icon = Icons.card_giftcard;
        color = Colors.purple;
        title = 'Bonus';
        subtitle = transaction.description ?? 'Daily bonus';
        break;
      case TransactionType.referralBonus:
        icon = Icons.people;
        color = Colors.blue;
        title = 'Referral Bonus';
        subtitle = transaction.description ?? 'Referral commission';
        break;
      case TransactionType.planPurchase:
        icon = Icons.shopping_cart;
        color = Colors.orange;
        title = 'Plan Purchase';
        subtitle = transaction.description ?? 'Subscription plan';
        break;
      case TransactionType.referralProfit:
        icon = Icons.attach_money;
        color = Colors.teal;
        title = 'Referral Profit';
        subtitle = transaction.description ?? 'From referral activity';
        break;
      default:
        icon = Icons.swap_horiz;
        color = Colors.grey;
        title = 'Transaction';
        subtitle = transaction.description ?? 'General transaction';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              Formatters.formatDateTime(transaction.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Text(
          (transaction.type == TransactionType.deposit ||
                  transaction.type == TransactionType.bonus ||
                  transaction.type == TransactionType.referralBonus ||
                  transaction.type == TransactionType.referralProfit)
              ? '+${Formatters.formatCurrency(transaction.amount)}'
              : '-${Formatters.formatCurrency(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                (transaction.type == TransactionType.deposit ||
                    transaction.type == TransactionType.bonus ||
                    transaction.type == TransactionType.referralBonus ||
                    transaction.type == TransactionType.referralProfit)
                ? Colors.green
                : Colors.red,
          ),
        ),
      ),
    );
  }
}
