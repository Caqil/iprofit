// lib/features/wallet/screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/wallet_provider.dart';
import '../providers/transaction_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/enums/transaction_status.dart';
import '../../../models/user.dart';
import '../../../models/transaction.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../app/theme.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen>
    with TickerProviderStateMixin {
  late AnimationController _balanceAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _shimmerAnimationController;
  late Animation<double> _balanceAnimation;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _shimmerAnimation;

  final TextEditingController _couponController = TextEditingController();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _balanceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _shimmerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _balanceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _balanceAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _cardSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _balanceAnimationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _balanceAnimationController.dispose();
    _cardAnimationController.dispose();
    _shimmerAnimationController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  // Create placeholder user for skeleton loading
  User _createPlaceholderUser() {
    return User(
      id: 0,
      name: 'John Doe',
      email: 'user@example.com',
      phone: '+1234567890',
      balance: 12458.32,
      referralCode: 'REF123',
      planId: 1,
      isKycVerified: true,
      isAdmin: false,
      isBlocked: false,
      biometricEnabled: false,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  // Create placeholder transactions for skeleton loading
  List<Transaction> _createPlaceholderTransactions() {
    return List.generate(
      3,
      (index) => Transaction(
        id: index,
        amount: [500.0, -150.0, 25.0][index],
        type: [
          TransactionType.deposit,
          TransactionType.withdrawal,
          TransactionType.bonus,
        ][index],
        status: TransactionStatus.completed,
        description: [
          'Deposit via CoinGate',
          'Withdrawal to bKash',
          'Referral Bonus',
        ][index],
        createdAt: DateTime.now()
            .subtract(Duration(hours: index))
            .toIso8601String(),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Refresh all wallet data
    ref.invalidate(walletProvider);
    ref.invalidate(transactionListProvider());

    await Future.wait([
      ref.refresh(walletProvider.future),
      ref.refresh(transactionListProvider().future),
    ]);

    setState(() => _isRefreshing = false);

    // Restart animations
    _balanceAnimationController.reset();
    _balanceAnimationController.forward();
  }

  Future<void> _handleDeposit() async {
    context.push('/deposit');
  }

  Future<void> _handleWithdraw() async {
    context.push('/withdrawal');
  }

  Future<void> _handleStats() async {
    context.push('/transactions');
  }

  Future<void> _handleBonus() async {
    // Show bonus dialog or navigate to bonus screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Claim your daily bonus!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Future<void> _applyCoupon() async {
    if (_couponController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
      return;
    }

    // TODO: Implement coupon API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applying coupon: ${_couponController.text}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );

    _couponController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Wallets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryColor,
        backgroundColor: const Color(0xFF2A2A2A),
        child: walletState.when(
          data: (walletData) => _buildContent(
            context,
            walletData['user'] ?? authState.valueOrNull,
            walletData['transactions'] ?? [],
            false,
          ),
          loading: () => _buildContent(
            context,
            _createPlaceholderUser(),
            _createPlaceholderTransactions(),
            true,
          ),
          error: (error, stackTrace) => _buildErrorContent(error.toString()),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    User? user,
    List<Transaction> transactions,
    bool isLoading,
  ) {
    final balance = user?.balance ?? 0.0;

    return Skeletonizer(
      enabled: isLoading,
      effect: const ShimmerEffect(
        baseColor: Color(0xFF2A2A2A),
        highlightColor: Color(0xFF3A3A3A),
        duration: Duration(milliseconds: 1000),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AnimatedBuilder(
          animation: _cardSlideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _cardSlideAnimation.value),
              child: Opacity(
                opacity: 1 - (_cardSlideAnimation.value / 30),
                child: Column(
                  spacing: 20,
                  children: [
                    const SizedBox(height: 8),
                    _buildBalanceCard(balance, isLoading),
                    _buildQuickActions(),
                    _buildRecentActivity(transactions),
                    _buildCouponSection(),
                    _buildPerformanceChart(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double balance, bool isLoading) {
    return BalanceGlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Shimmer effect overlay for glass effect
              if (!isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment(
                          -1.0 + _shimmerAnimation.value * 2,
                          0.0,
                        ),
                        end: Alignment(1.0 + _shimmerAnimation.value * 2, 0.0),
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: AppTheme.primaryColor,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'TOTAL BALANCE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _handleRefresh,
                        child: AnimatedRotation(
                          turns: _isRefreshing ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1000),
                          child: ActionGlassContainer(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _balanceAnimation,
                    builder: (context, child) {
                      final animatedBalance = balance * _balanceAnimation.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$ ${Formatters.formatCurrency(animatedBalance)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'USD',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            icon: Icons.add,
            label: 'Deposit',
            onTap: _handleDeposit,
          ),
          _buildActionButton(
            icon: Icons.arrow_outward,
            label: 'Withdraw',
            onTap: _handleWithdraw,
          ),
          _buildActionButton(
            icon: Icons.bar_chart,
            label: 'Stats',
            onTap: _handleStats,
          ),
          _buildActionButton(
            icon: Icons.card_giftcard,
            label: 'Bonus',
            onTap: _handleBonus,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: ActionGlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<Transaction> transactions) {
    return GlassContainer(
      glassType: GlassType.dark,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/transactions'),
                child: const Text(
                  'Date',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...transactions
              .take(5)
              .map((transaction) => _buildActivityItem(transaction)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Transaction transaction) {
    IconData icon;
    Color color;
    String statusText;

    switch (transaction.type) {
      case TransactionType.deposit:
        icon = Icons.add_circle;
        color = const Color(0xFF10B981);
        statusText = 'Completed';
        break;
      case TransactionType.withdrawal:
        icon = Icons.remove_circle;
        color = const Color(0xFFF59E0B);
        statusText = 'Pending';
        break;
      case TransactionType.bonus:
        icon = Icons.card_giftcard;
        color = const Color(0xFF8B5CF6);
        statusText = 'Credited';
        break;
      default:
        icon = Icons.swap_horiz;
        color = AppTheme.primaryColor;
        statusText = 'Completed';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          StatGlassContainer(
            padding: const EdgeInsets.all(8),
            accentColor: color,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? transaction.type.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.formatDateTime(transaction.createdAt),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.amount >= 0 ? '+' : ''}\$${transaction.amount.abs()}',
                style: TextStyle(
                  color: transaction.amount >= 0
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              NotificationGlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isSuccess: transaction.type == TransactionType.deposit,
                isWarning: transaction.type == TransactionType.withdrawal,
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return GlassContainer(
      glassType: GlassType.dark,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatGlassContainer(
                padding: const EdgeInsets.all(6),
                accentColor: AppTheme.primaryColor,
                child: const Icon(
                  Icons.local_offer,
                  color: AppTheme.primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Have a Coupon?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GlassContainer(
                  glassType: GlassType.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  child: TextField(
                    controller: _couponController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter Coupon Code',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ActionGlassContainer(
                onTap: _applyCoupon,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return GlassContainer(
      glassType: GlassType.dark,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Wallet Performance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Last 7 days',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        if (value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 12200),
                      const FlSpot(1, 12350),
                      const FlSpot(2, 12100),
                      const FlSpot(3, 12400),
                      const FlSpot(4, 12600),
                      const FlSpot(5, 12350),
                      const FlSpot(6, 12458),
                    ],
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String error) {
    return Center(
      child: GlassContainer(
        glassType: GlassType.error,
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 16),
            const Text(
              'Error loading wallet data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ActionGlassContainer(
              onTap: _handleRefresh,
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
