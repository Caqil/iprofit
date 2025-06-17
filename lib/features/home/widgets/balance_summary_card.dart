// lib/features/home/widgets/balance_summary_card.dart
import 'package:app/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../../models/user.dart';
import '../../../core/utils/formatters.dart';
import '../providers/home_provider.dart';

class BalanceSummaryCard extends ConsumerStatefulWidget {
  final User user;
  final List<ProfitData> profitData;

  const BalanceSummaryCard({
    super.key,
    required this.user,
    required this.profitData,
  });

  @override
  ConsumerState<BalanceSummaryCard> createState() => _BalanceSummaryCardState();
}

class _BalanceSummaryCardState extends ConsumerState<BalanceSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _percentageAnimation;
  late Animation<double> _amountAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _percentageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _amountAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeNotifier = ref.read(homeProvider.notifier);
    final theme = Theme.of(context);
    // Get real data from the provider
    final todaysProfit = homeNotifier.getTodaysProfit();
    final percentChange = homeNotifier.getProfitPercentageChange();
    final isPositive = percentChange >= 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.canvasColor,
                      theme.primaryColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.disabledColor.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Total Balance section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: AppTheme.primaryColor,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Total Balance',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            _buildGlassButton(
                              'Active Plan',
                              icon: Icons.diamond_outlined,
                              onTap: () {
                                // Navigate to active plan or upgrade plan
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Balance amount with percentage
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _amountAnimation,
                              builder: (context, _) {
                                return Text(
                                  Formatters.formatCurrency(
                                    widget.user.balance *
                                        _amountAnimation.value,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 5),
                            if (percentChange !=
                                0) // Only show if there's actual change
                              _buildPercentageIndicator(
                                percentChange,
                                isPositive,
                              ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.05),
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Today's Profit and Plan Type
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoBlock(
                                'Today\'s Profit',
                                '+${Formatters.formatCurrency(todaysProfit)}',
                                icon: Icons.trending_up,
                                iconColor: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            // Plan Type
                            Expanded(
                              child: _buildInfoBlock(
                                'Plan Type',
                                _getPlanType(),
                                icon: Icons.stars,
                                iconColor: const Color(0xFFF4D03F),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton(
    String label, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageIndicator(double percentChange, bool isPositive) {
    return AnimatedBuilder(
      animation: _percentageAnimation,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: (isPositive ? AppTheme.primaryColor : Colors.red)
                .withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (isPositive ? AppTheme.primaryColor : Colors.red)
                  .withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? AppTheme.primaryColor : Colors.red,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}${(percentChange * _percentageAnimation.value).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isPositive ? AppTheme.primaryColor : Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBlock(
    String label,
    String value, {
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 14),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          FadeTransition(
            opacity: _amountAnimation,
            child: Text(
              value,
              style: TextStyle(
                color: label.contains('Profit')
                    ? AppTheme.primaryColor
                    : AppTheme.accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPlanType() {
    // Determine plan type based on user data
    if (widget.user.isKycVerified) {
      return 'Premium';
    } else if (widget.user.balance > 0) {
      return 'Active';
    } else {
      return 'Basic';
    }
  }
}
