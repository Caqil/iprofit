// lib/features/wallet/screens/deposit_screen.dart
import 'package:app/app/theme.dart';
import 'package:app/core/utils/validators.dart';
import 'package:app/core/utils/formatters.dart';
import 'package:app/features/wallet/providers/deposit_provider.dart';
import 'package:app/features/wallet/providers/wallet_provider.dart';
import 'package:app/features/auth/providers/auth_provider.dart';
import 'package:app/shared/widgets/custom_text_field.dart';
import 'package:app/shared/widgets/loading_button.dart';
import 'package:app/shared/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _senderAccountController = TextEditingController();

  String _selectedMethod = 'CoinGate';
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
    _transactionIdController.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _senderAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

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
          'Deposit',
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
    final transactions = data['transactions'] ?? [];
    final balance = user?.balance ?? 0.0;

    // Filter for deposit transactions only
    final deposits = transactions
        .where((t) => t.type?.toString().contains('deposit') == true)
        .toList();

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

                  // Deposit Amount Section
                  _buildDepositAmountSection(isLoading),
                  const SizedBox(height: 24),

                  // Select Method Section
                  _buildSelectMethodSection(isLoading),
                  const SizedBox(height: 24),

                  // Payment Details Section (conditional)
                  if (_selectedMethod == 'Manual') ...[
                    _buildPaymentDetailsSection(isLoading),
                    const SizedBox(height: 24),
                  ],

                  // Deposit Button
                  _buildDepositButton(isLoading),
                  const SizedBox(height: 32),

                  // Recent Deposits Section
                  _buildRecentDepositsSection(deposits, isLoading),
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
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.green,
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

  Widget _buildDepositAmountSection(bool isLoading) {
    return GlassContainer(
      glassType: GlassType.secondary,
      shadowType: ShadowType.soft,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Deposit Amount',
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
            hint: 'Minimum \$10',
            prefixIcon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Amount is required';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount < 10) {
                return 'Minimum deposit amount is \$10';
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
        'name': 'CoinGate',
        'subtitle': 'Bitcoin, Ethereum, USDT',
        'icon': Icons.currency_bitcoin,
        'color': const Color(0xFFF7931A),
      },
      {
        'name': 'UddoktaPay',
        'subtitle': 'bKash, Nagad, Rocket',
        'icon': Icons.mobile_friendly,
        'color': const Color(0xFF00C851),
      },
      {
        'name': 'Manual',
        'subtitle': 'Bank Transfer, Mobile Banking',
        'icon': Icons.account_balance,
        'color': const Color(0xFF2196F3),
      },
    ];

    return GlassContainer(
      glassType: GlassType.secondary,
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
          ...methods.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMethodCard(
                method['name'] as String,
                method['subtitle'] as String,
                method['icon'] as IconData,
                method['color'] as Color,
                _selectedMethod == method['name'],
                isLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(
    String name,
    String subtitle,
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
                // Clear manual payment fields when switching methods
                if (name != 'Manual') {
                  _transactionIdController.clear();
                  _senderNameController.clear();
                  _senderPhoneController.clear();
                  _senderAccountController.clear();
                }
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : const Color(0xFF2A2A2A).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer.zone(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: isSelected ? color : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Skeletonizer.zone(
                    child: Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsSection(bool isLoading) {
    return GlassContainer(
      glassType: GlassType.secondary,
      shadowType: ShadowType.soft,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Payment Details',
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
            controller: _transactionIdController,
            label: 'Transaction ID',
            hint: 'Enter transaction ID from your payment',
            prefixIcon: Icons.receipt,
            validator: (value) {
              if (_selectedMethod == 'Manual' &&
                  (value == null || value.isEmpty)) {
                return 'Transaction ID is required for manual deposits';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _senderNameController,
            label: 'Sender Name',
            hint: 'Enter sender full name',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (_selectedMethod == 'Manual' &&
                  (value == null || value.isEmpty)) {
                return 'Sender name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _senderPhoneController,
            label: 'Sender Phone',
            hint: 'Enter sender phone number',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (_selectedMethod == 'Manual' &&
                  (value == null || value.isEmpty)) {
                return 'Sender phone is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _senderAccountController,
            label: 'Sender Account (Optional)',
            hint: 'Enter sender account number',
            prefixIcon: Icons.account_balance_wallet,
          ),
        ],
      ),
    );
  }

  Widget _buildDepositButton(bool isLoading) {
    final manualDepositState = ref.watch(manualDepositProvider);
    final coinGateDepositState = ref.watch(coinGateDepositProvider);
    final uddoktapayDepositState = ref.watch(uddoktapayDepositProvider);

    final isRequestLoading =
        manualDepositState is AsyncLoading ||
        coinGateDepositState is AsyncLoading ||
        uddoktapayDepositState is AsyncLoading;

    return AnimatedScale(
      scale: isRequestLoading ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GlassContainer(
        glassType: GlassType.success,
        shadowType: ShadowType.medium,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(16),
        onTap: isLoading || isRequestLoading ? null : _handleDeposit,
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
                Icon(Icons.arrow_circle_up, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                isRequestLoading ? 'Processing...' : 'Deposit Now',
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

  Widget _buildRecentDepositsSection(List deposits, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, color: Colors.grey[400], size: 20),
            const SizedBox(width: 8),
            const Text(
              'Recent Deposits',
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
        if (deposits.isEmpty && !isLoading)
          GlassContainer(
            glassType: GlassType.secondary,
            shadowType: ShadowType.soft,
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(12),
            child: const Center(
              child: Text(
                'No recent deposits',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          ...List.generate(
            isLoading ? 3 : deposits.length.clamp(0, 3),
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDepositItem(
                isLoading ? _createPlaceholderDeposit() : deposits[index],
                isLoading,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDepositItem(dynamic deposit, bool isLoading) {
    final amount = deposit.amount ?? 250.0;
    final gateway = deposit.gateway ?? 'coingate';
    final status = deposit.status ?? 'completed';
    final date = deposit.createdAt ?? DateTime.now().toIso8601String();

    Color statusColor;
    IconData statusIcon;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'failed':
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
    String methodName;
    switch (gateway.toString().toLowerCase()) {
      case 'coingate':
        methodIcon = Icons.currency_bitcoin;
        methodColor = const Color(0xFFF7931A);
        methodName = 'CoinGate';
        break;
      case 'uddoktapay':
        methodIcon = Icons.mobile_friendly;
        methodColor = const Color(0xFF00C851);
        methodName = 'UddoktaPay';
        break;
      case 'manual':
        methodIcon = Icons.account_balance;
        methodColor = const Color(0xFF2196F3);
        methodName = 'Manual';
        break;
      default:
        methodIcon = Icons.payment;
        methodColor = Colors.blue;
        methodName = 'Payment';
    }

    return GlassContainer(
      glassType: GlassType.secondary,
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
                    methodName,
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
                    'Today, 10:12 AM',
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
                  '+\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
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
                    status.toString().substring(0, 1).toUpperCase() +
                        status.toString().substring(1),
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
      'transactions': List.generate(3, (_) => _createPlaceholderDeposit()),
    };
  }

  dynamic _createPlaceholderUser() {
    return {'balance': 2150.40};
  }

  dynamic _createPlaceholderDeposit() {
    return {
      'amount': 250.0,
      'gateway': 'coingate',
      'status': 'completed',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  Future<void> _handleDeposit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final amount = double.parse(_amountController.text);

        if (_selectedMethod == 'CoinGate') {
          final result = await ref
              .read(coinGateDepositProvider.notifier)
              .deposit(amount);

          // Handle redirect to CoinGate payment gateway
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Redirecting to CoinGate payment gateway...',
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        } else if (_selectedMethod == 'UddoktaPay') {
          final result = await ref
              .read(uddoktapayDepositProvider.notifier)
              .deposit(amount);

          // Handle redirect to UddoktaPay payment gateway
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Redirecting to UddoktaPay payment gateway...',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        } else {
          // Manual deposit
          await ref
              .read(manualDepositProvider.notifier)
              .deposit(
                amount: amount,
                transactionId: _transactionIdController.text,
                paymentMethod: 'Bank Transfer',
                senderInformation: {
                  'name': _senderNameController.text,
                  'phone': _senderPhoneController.text,
                  'account': _senderAccountController.text.isNotEmpty
                      ? _senderAccountController.text
                      : null,
                },
              );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Deposit submitted successfully! It will be reviewed by admin.',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            // Clear form
            _amountController.clear();
            _transactionIdController.clear();
            _senderNameController.clear();
            _senderPhoneController.clear();
            _senderAccountController.clear();

            // Refresh wallet data
            ref.invalidate(walletProvider);
          }
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
