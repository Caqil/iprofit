// lib/features/home/widgets/balance_summary_card.dart
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

    // Get real data from the provider
    final todaysProfit = homeNotifier.getTodaysProfit();
    final percentChange = homeNotifier.getProfitPercentageChange();
    final isPositive = percentChange >= 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4AA).withOpacity(0.1),
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
                    colors: const [Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    // Shimmer effect
                    Positioned.fill(
                      child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Transform.translate(
                          offset: Offset(
                            _shimmerAnimation.value *
                                MediaQuery.of(context).size.width,
                            0,
                          ),
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Card content
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
                                  color: Color(0xFF00D4AA),
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Total Balance',
                                  style: TextStyle(
                                    color: Color(0xFF8E8E8E),
                                    fontSize: 14,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            if (percentChange !=
                                0) // Only show if there's actual change
                              _buildPercentageIndicator(
                                percentChange,
                                isPositive,
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),

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
                        const SizedBox(height: 24),

                        // Today's Profit and Plan Type
                        Row(
                          children: [
                            // Today's Profit
                            Expanded(
                              child: _buildInfoBlock(
                                'Today\'s Profit',
                                '+${Formatters.formatCurrency(todaysProfit)}',
                                icon: Icons.trending_up,
                                iconColor: const Color(0xFF00D4AA),
                              ),
                            ),

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF00D4AA), size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF00D4AA),
                fontSize: 12,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: (isPositive ? const Color(0xFF00D4AA) : Colors.red)
                .withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (isPositive ? const Color(0xFF00D4AA) : Colors.red)
                  .withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? const Color(0xFF00D4AA) : Colors.red,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}${(percentChange * _percentageAnimation.value).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isPositive ? const Color(0xFF00D4AA) : Colors.red,
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
              Text(
                label,
                style: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FadeTransition(
            opacity: _amountAnimation,
            child: Text(
              value,
              style: TextStyle(
                color: label.contains('Profit')
                    ? const Color(0xFF00D4AA)
                    : Colors.white,
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
