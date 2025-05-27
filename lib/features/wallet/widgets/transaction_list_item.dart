// lib/features/wallet/widgets/transaction_list_item.dart
import 'package:flutter/material.dart';
import '../../../models/transaction.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/enums/transaction_status.dart';
import '../../../core/utils/formatters.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionListItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color color;
    final String title;
    final String subtitle;
    final String amountPrefix;

    // Determine icon, color, and text based on transaction type
    switch (transaction.type) {
      case TransactionType.deposit:
        icon = Icons.add_circle;
        color = Colors.green;
        title = 'Deposit';
        subtitle = transaction.description ?? 'Deposit to your account';
        amountPrefix = '+';
        break;
      case TransactionType.withdrawal:
        icon = Icons.remove_circle;
        color = Colors.red;
        title = 'Withdrawal';
        subtitle = transaction.description ?? 'Withdrawal from your account';
        amountPrefix = '-';
        break;
      case TransactionType.bonus:
        icon = Icons.card_giftcard;
        color = Colors.purple;
        title = 'Bonus';
        subtitle = transaction.description ?? 'Bonus added to your account';
        amountPrefix = '+';
        break;
      case TransactionType.referralBonus:
        icon = Icons.people;
        color = Colors.blue;
        title = 'Referral Bonus';
        subtitle = transaction.description ?? 'Bonus from referral';
        amountPrefix = '+';
        break;
      case TransactionType.planPurchase:
        icon = Icons.shopping_cart;
        color = Colors.orange;
        title = 'Plan Purchase';
        subtitle = transaction.description ?? 'Purchased investment plan';
        amountPrefix = '-';
        break;
      case TransactionType.referralProfit:
        icon = Icons.attach_money;
        color = Colors.teal;
        title = 'Referral Profit';
        subtitle = transaction.description ?? 'Profit from referral activity';
        amountPrefix = '+';
        break;
      default:
        icon = Icons.swap_horiz;
        color = Colors.grey;
        title = 'Transaction';
        subtitle = transaction.description ?? 'General transaction';
        amountPrefix = '';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Transaction icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              const SizedBox(width: 16),

              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Status badge
                        _buildStatusBadge(transaction.status),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Date and time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatDateTime(transaction.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),

                        // Amount
                        Text(
                          '$amountPrefix${Formatters.formatCurrency(transaction.amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    String text;

    switch (status) {
      case TransactionStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case TransactionStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case TransactionStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
