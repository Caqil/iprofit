// lib/features/home/widgets/todays_log_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/transaction.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/utils/formatters.dart';

class TodaysLogCard extends StatelessWidget {
  final List<Transaction> transactions;

  const TodaysLogCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Filter today's transactions
    final today = DateTime.now();
    final todaysTransactions = transactions.where((transaction) {
      final transactionDate = DateTime.parse(transaction.createdAt);
      return transactionDate.year == today.year &&
          transactionDate.month == today.month &&
          transactionDate.day == today.day;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.history,
                      color: AppTheme.primaryColor,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Today\'s Log',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/transactions'),
                child: const Text(
                  'See All',
                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transactions list
          if (todaysTransactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No transactions today',
                  style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
                ),
              ),
            )
          else
            ...todaysTransactions
                .take(3)
                .map((transaction) => _LogItem(transaction: transaction))
                .toList(),
        ],
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final Transaction transaction;

  const _LogItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final (icon, color, title) = _getTransactionDisplayData();
    final isPositive = _isPositiveTransaction();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.getTimeAgo(transaction.createdAt),
                  style: const TextStyle(
                    color: Color(0xFF8E8E8E),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${isPositive ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
            style: TextStyle(
              color: isPositive
                  ? AppTheme.primaryColor
                  : const Color(0xFFFF6B6B),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color, String) _getTransactionDisplayData() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return (Icons.add_circle_outline, AppTheme.primaryColor, 'Deposit');
      case TransactionType.withdrawal:
        return (
          Icons.arrow_circle_up_outlined,
          const Color(0xFFFF6B6B),
          'Withdrawal',
        );
      case TransactionType.bonus:
        return (Icons.card_giftcard_outlined, const Color(0xFF8B5CF6), 'Bonus');
      case TransactionType.referralBonus:
        return (
          Icons.people_outline,
          const Color(0xFF6366F1),
          'Referral Bonus',
        );
      case TransactionType.planPurchase:
        return (
          Icons.shopping_cart_outlined,
          const Color(0xFFFF8C00),
          'Plan Purchase',
        );
      case TransactionType.referralProfit:
        return (Icons.trending_up, AppTheme.primaryColor, 'Referral Profit');
      default:
        return (Icons.swap_horiz, const Color(0xFF8E8E8E), 'Transaction');
    }
  }

  bool _isPositiveTransaction() {
    return [
      TransactionType.deposit,
      TransactionType.bonus,
      TransactionType.referralBonus,
      TransactionType.referralProfit,
    ].contains(transaction.type);
  }
}
