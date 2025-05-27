// lib/features/wallet/widgets/withdrawal_status_card.dart
import 'package:flutter/material.dart';
import '../../../models/withdrawal.dart';
import '../../../core/utils/formatters.dart';

class WithdrawalStatusCard extends StatelessWidget {
  final Withdrawal withdrawal;

  const WithdrawalStatusCard({super.key, required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    final String statusText;
    final Color statusColor;
    final IconData statusIcon;

    switch (withdrawal.status.toLowerCase()) {
      case 'pending':
        statusText = 'Pending';
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_top;
        break;
      case 'approved':
        statusText = 'Approved';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusText = 'Rejected';
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusText = 'Unknown';
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(statusIcon, color: statusColor),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Withdrawal #${withdrawal.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.formatDateTime(withdrawal.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Amount',
              Formatters.formatCurrency(withdrawal.amount),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Payment Method', withdrawal.paymentMethod),

            // Display payment details
            const SizedBox(height: 16),
            const Text(
              'Payment Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...withdrawal.paymentDetails.entries.map((entry) {
              final key = entry.key;
              final value = entry.value.toString();

              // Format payment detail keys for display (convert snake_case to Title Case)
              final formattedKey = key
                  .split('_')
                  .map(
                    (word) => word.isEmpty
                        ? ''
                        : word[0].toUpperCase() + word.substring(1),
                  )
                  .join(' ');

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildInfoRow(context, formattedKey, value),
              );
            }).toList(),

            // Admin note if exists and status is rejected
            if (withdrawal.status.toLowerCase() == 'rejected' &&
                withdrawal.adminNote != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Rejection Reason',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      withdrawal.adminNote!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
