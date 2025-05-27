// lib/features/home/widgets/balance_summary_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user.dart';
import '../../../core/utils/formatters.dart';
import '../providers/home_provider.dart';

class BalanceSummaryCard extends ConsumerWidget {
  final User user;
  final List<ProfitData> profitData;

  const BalanceSummaryCard({
    super.key,
    required this.user,
    required this.profitData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);

    // Get real data from the provider
    final todaysProfit = homeNotifier.getTodaysProfit();
    final percentChange = homeNotifier.getProfitPercentageChange();
    final isPositive = percentChange >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Balance section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to active plan or upgrade plan
                },
                child: const Text(
                  'Active Plan',
                  style: TextStyle(color: Color(0xFF00D4AA), fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Balance amount with percentage
          Row(
            children: [
              Text(
                Formatters.formatCurrency(user.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              if (percentChange != 0) // Only show if there's actual change
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? const Color(0xFF00D4AA).withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPositive
                            ? const Color(0xFF00D4AA)
                            : Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${isPositive ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: isPositive
                              ? const Color(0xFF00D4AA)
                              : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Today's Profit and Plan Type
          Row(
            children: [
              // Today's Profit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Profit',
                      style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${Formatters.formatCurrency(todaysProfit)}',
                      style: const TextStyle(
                        color: Color(0xFF00D4AA),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Plan Type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan Type',
                      style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPlanType(),
                      style: const TextStyle(
                        color: Color(0xFF00D4AA),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPlanType() {
    // Determine plan type based on user data
    if (user.isKycVerified) {
      return 'Premium Member';
    } else if (user.balance > 0) {
      return 'Active Member';
    } else {
      return 'Basic Plan';
    }
  }
}
