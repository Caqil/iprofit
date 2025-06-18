// lib/features/wallet/screens/withdrawal_screen.dart
import 'package:app/app/theme.dart';
import 'package:app/core/utils/validators.dart';
import 'package:app/core/utils/formatters.dart';
import 'package:app/features/wallet/providers/withdrawal_provider.dart';
import 'package:app/features/wallet/providers/wallet_provider.dart';
import 'package:app/features/auth/providers/auth_provider.dart';
import 'package:app/shared/widgets/custom_text_field.dart';
import 'package:app/shared/widgets/loading_button.dart';
import 'package:app/shared/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  final _accountHolderController = TextEditingController();

  String _selectedMethod = 'bKash';
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _amountController.dispose();
    _accountController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final withdrawalRequestState = ref.watch(withdrawalRequestProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        backgroundColor: const Color(0xFF2A2A2A),
        onRefresh: () async {
          ref.invalidate(walletProvider);
          await ref.read(walletProvider.future);
        },
        child: walletState.when(
          data: (data) => _buildContent(data, false),
          loading: () => _buildContent(_createPlaceholderData(), true),
          error: (error, stackTrace) => _buildErrorContent(error.toString()),
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data, bool isLoading) {
    final user = data['user'];
    final withdrawals = data['withdrawals'] ?? [];
    final balance = user?.balance ?? 0.0;

    return Skeletonizer(
      enabled: isLoading,
      effect: const ShimmerEffect(
        baseColor: Color(0xFF2A2A2A),
        highlightColor: Color(0xFF3A3A3A),
        duration: Duration(milliseconds: 1000),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Balance Card
                  _buildBalanceCard(balance, isLoading),
                  const SizedBox(height: 24),

                  // Withdraw Amount Section
                  _buildWithdrawAmountSection(isLoading),
                  const SizedBox(height: 24),

                  // Select Method Section
                  _buildSelectMethodSection(isLoading),
                  const SizedBox(height: 24),

                  // Account Credentials Section
                  _buildAccountCredentialsSection(isLoading),
                  const SizedBox(height: 32),

                  // Withdraw Button
                  _buildWithdrawButton(isLoading),
                  const SizedBox(height: 32),

                  // Recent Withdrawals Section
                  _buildRecentWithdrawalsSection(withdrawals, isLoading),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double balance, bool isLoading) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return GlassContainer(
          glassType: GlassType.primary,
          shadowType: ShadowType.medium,
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Available',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Skeletonizer.zone(
                child: Text(
                  Formatters.formatCurrency(balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWithdrawAmountSection(bool isLoading) {
    return GlassContainer(
      glassType: GlassType.primary,
      shadowType: ShadowType.soft,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_down, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Withdraw Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _amountController,
            label: 'Amount',
            hint: 'Minimum \$100',
            prefixIcon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Amount is required';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount < 100) {
                return 'Minimum withdrawal amount is \$100';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectMethodSection(bool isLoading) {
    final methods = [
      {
        'name': 'bKash',
        'icon': Icons.phone_android,
        'color': const Color(0xFFE2136E),
      },
      {
        'name': 'Nagad',
        'icon': Icons.phone_iphone,
        'color': const Color(0xFFFF6B35),
      },
      {
        'name': 'Binance',
        'icon': Icons.currency_bitcoin,
        'color': const Color(0xFFF0B90B),
      },
    ];

    return GlassContainer(
      glassType: GlassType.primary,
      shadowType: ShadowType.soft,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Select Method',
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
            children: methods.map((method) {
              final isSelected = _selectedMethod == method['name'];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildMethodCard(
                    method['name'] as String,
                    method['icon'] as IconData,
                    method['color'] as Color,
                    isSelected,
                    isLoading,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(
    String name,
    IconData icon,
    Color color,
    bool isSelected,
    bool isLoading,
  ) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              setState(() {
                _selectedMethod = name;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : const Color(0xFF2A2A2A).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Skeletonizer.zone(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected ? color : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCredentialsSection(bool isLoading) {
    return GlassContainer(
      glassType: GlassType.primary,
      shadowType: ShadowType.soft,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle_outlined,
                color: Colors.purple,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Account Credentials',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _accountController,
            label: 'Enter Account Number/Wallet ID',
            hint: 'Account number or wallet address',
            prefixIcon: Icons.numbers,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Account information is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _accountHolderController,
            label: 'Account Holder Name (optional)',
            hint: 'Enter account holder name',
            prefixIcon: Icons.person_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawButton(bool isLoading) {
    final withdrawalRequestState = ref.watch(withdrawalRequestProvider);
    final isRequestLoading = withdrawalRequestState is AsyncLoading;

    return AnimatedScale(
      scale: isRequestLoading ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GlassContainer(
        glassType: GlassType.primary,
        shadowType: ShadowType.medium,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(16),
        onTap: isLoading || isRequestLoading ? null : _handleWithdrawal,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isRequestLoading) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 12),
              ] else ...[
                Icon(Icons.arrow_circle_down, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                isRequestLoading ? 'Processing...' : 'Withdraw Now',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentWithdrawalsSection(List withdrawals, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, color: Colors.grey[400], size: 20),
            const SizedBox(width: 8),
            const Text(
              'Recent Withdrawals',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/transactions'),
              child: const Text(
                'See All',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (withdrawals.isEmpty && !isLoading)
          GlassContainer(
            glassType: GlassType.primary,
            shadowType: ShadowType.soft,
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(12),
            child: const Center(
              child: Text(
                'No recent withdrawals',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          ...List.generate(
            isLoading ? 3 : withdrawals.length.clamp(0, 3),
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildWithdrawalItem(
                isLoading ? _createPlaceholderWithdrawal() : withdrawals[index],
                isLoading,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWithdrawalItem(dynamic withdrawal, bool isLoading) {
    final amount = withdrawal.amount ?? 120.0;
    final method = withdrawal.paymentMethod ?? 'bKash';
    final status = withdrawal.status ?? 'Processing';
    final date = withdrawal.createdAt ?? DateTime.now().toIso8601String();

    Color statusColor;
    IconData statusIcon;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
    }

    IconData methodIcon;
    Color methodColor;
    switch (method.toLowerCase()) {
      case 'bkash':
        methodIcon = Icons.phone_android;
        methodColor = const Color(0xFFE2136E);
        break;
      case 'nagad':
        methodIcon = Icons.phone_iphone;
        methodColor = const Color(0xFFFF6B35);
        break;
      case 'binance':
        methodIcon = Icons.currency_bitcoin;
        methodColor = const Color(0xFFF0B90B);
        break;
      default:
        methodIcon = Icons.account_balance;
        methodColor = Colors.blue;
    }

    return GlassContainer(
      glassType: GlassType.primary,
      shadowType: ShadowType.soft,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: methodColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(methodIcon, color: methodColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeletonizer.zone(
                  child: Text(
                    method,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Skeletonizer.zone(
                  child: Text(
                    '01xxxxxxxxx',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Skeletonizer.zone(
                child: Text(
                  '-\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Skeletonizer.zone(
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String error) {
    return Center(
      child: GlassContainer(
        glassType: GlassType.error,
        shadowType: ShadowType.medium,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error Loading Data',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GlassContainer(
              glassType: GlassType.primary,
              shadowType: ShadowType.soft,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                ref.invalidate(walletProvider);
              },
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _createPlaceholderData() {
    return {
      'user': _createPlaceholderUser(),
      'withdrawals': List.generate(3, (_) => _createPlaceholderWithdrawal()),
    };
  }

  dynamic _createPlaceholderUser() {
    return {'balance': 2150.40};
  }

  dynamic _createPlaceholderWithdrawal() {
    return {
      'amount': 120.0,
      'paymentMethod': 'bKash',
      'status': 'Processing',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  Future<void> _handleWithdrawal() async {
    if (_formKey.currentState!.validate()) {
      try {
        final amount = double.parse(_amountController.text);

        await ref
            .read(withdrawalRequestProvider.notifier)
            .requestWithdrawal(
              amount: amount,
              paymentMethod: _selectedMethod,
              paymentDetails: {
                'account_number': _accountController.text,
                'account_holder_name': _accountHolderController.text.isNotEmpty
                    ? _accountHolderController.text
                    : null,
              },
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Withdrawal request submitted successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Clear form
          _amountController.clear();
          _accountController.clear();
          _accountHolderController.clear();

          // Refresh wallet data
          ref.invalidate(walletProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }
  }
}
