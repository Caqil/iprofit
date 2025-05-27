// lib/features/plans/widgets/purchase_plan_dialog.dart
import 'package:flutter/material.dart';
import '../../../models/plan.dart';
import '../../../core/utils/formatters.dart';

class PurchasePlanDialog extends StatelessWidget {
  final Plan plan;
  final double userBalance;
  final VoidCallback onConfirm;

  const PurchasePlanDialog({
    super.key,
    required this.plan,
    required this.userBalance,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPurchase = userBalance >= plan.price;

    return AlertDialog(
      title: const Text('Confirm Plan Purchase'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You are about to purchase the ${plan.name} plan.'),
          const SizedBox(height: 16),
          _buildInfoRow('Plan Price', Formatters.formatCurrency(plan.price)),
          _buildInfoRow('Your Balance', Formatters.formatCurrency(userBalance)),
          const SizedBox(height: 16),
          if (!canPurchase)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Insufficient balance. Please deposit more funds to purchase this plan.',
                      style: TextStyle(color: Colors.red[800]),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: canPurchase ? onConfirm : null,
          child: const Text('Purchase'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
