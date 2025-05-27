// lib/features/home/widgets/recent_transactions.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/transaction.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/enums/transaction_status.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactions({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.push('/transactions'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (transactions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return _buildTransactionItem(context, transaction);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final IconData icon;
    final Color color;
    final String title;

    // Determine icon and color based on transaction type
    switch (transaction.type) {
      case TransactionType.deposit:
        icon = Icons.add_circle;
        color = Colors.green;
        title = 'Deposit';
        break;
      case TransactionType.withdrawal:
        icon = Icons.remove_circle;
        color = Colors.red;
        title = 'Withdrawal';
        break;
      case TransactionType.bonus:
        icon = Icons.card_giftcard;
        color = Colors.purple;
        title = 'Bonus';
        break;
      case TransactionType.referralBonus:
        icon = Icons.people;
        color = Colors.blue;
        title = 'Referral Bonus';
        break;
      case TransactionType.planPurchase:
        icon = Icons.shopping_cart;
        color = Colors.orange;
        title = 'Plan Purchase';
        break;
      case TransactionType.referralProfit:
        icon = Icons.attach_money;
        color = Colors.teal;
        title = 'Referral Profit';
        break;
      default:
        icon = Icons.swap_horiz;
        color = Colors.grey;
        title = 'Transaction';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatDateTime(transaction.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
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
              const SizedBox(height: 4),
              _buildStatusBadge(transaction.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    String label;

    switch (status) {
      case TransactionStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        break;
      case TransactionStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case TransactionStatus.rejected:
        color = Colors.red;
        label = 'Rejected';
        break;
      default:
        color = Colors.grey;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
