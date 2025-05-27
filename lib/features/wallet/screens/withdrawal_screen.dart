// lib/features/wallet/screens/withdrawal_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wallet_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/formatters.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Bank Transfer';

  // Bank transfer fields
  final _bankNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();

  // Mobile banking fields
  final _mobileNumberController = TextEditingController();
  final _serviceProviderController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _mobileNumberController.dispose();
    _serviceProviderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final withdrawalState = ref.watch(withdrawalProvider);
    final isLoading = withdrawalState.isLoading;

    final authState = ref.watch(authProvider);
    final balance = authState.valueOrNull?.balance ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw Funds')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance display
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Balance',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        Formatters.formatCurrency(balance),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Amount field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter withdrawal amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }

                  try {
                    final amount = double.parse(value);

                    if (amount <= 0) {
                      return 'Amount must be greater than 0';
                    }

                    if (amount > balance) {
                      return 'Insufficient balance';
                    }

                    if (amount < 100) {
                      return 'Minimum withdrawal amount is \$100';
                    }
                  } catch (e) {
                    return 'Invalid amount';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Payment method selection
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              _buildPaymentMethodSelection(),

              const SizedBox(height: 24),

              // Payment details fields
              const Text(
                'Payment Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Show fields based on selected payment method
              if (_selectedPaymentMethod == 'Bank Transfer')
                _buildBankTransferFields()
              else if (_selectedPaymentMethod == 'Mobile Banking')
                _buildMobileBankingFields(),

              const SizedBox(height: 32),

              // Withdrawal button
              SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  onPressed: _requestWithdrawal,
                  text: 'Request Withdrawal',
                  isLoading: isLoading,
                ),
              ),

              const SizedBox(height: 16),

              // Important notes
              Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade800,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Important Notes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Minimum withdrawal amount is \$100\n'
                        '• Withdrawals are processed within 24-48 hours\n'
                        '• Make sure your payment details are correct',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Bank Transfer'),
            value: 'Bank Transfer',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Mobile Banking'),
            value: 'Mobile Banking',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBankTransferFields() {
    return Column(
      children: [
        TextFormField(
          controller: _bankNameController,
          decoration: const InputDecoration(
            labelText: 'Bank Name',
            hintText: 'Enter your bank name',
          ),
          validator: (value) => value!.isEmpty ? 'Bank name is required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _accountNameController,
          decoration: const InputDecoration(
            labelText: 'Account Name',
            hintText: 'Enter account holder name',
          ),
          validator: (value) =>
              value!.isEmpty ? 'Account name is required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _accountNumberController,
          decoration: const InputDecoration(
            labelText: 'Account Number',
            hintText: 'Enter your account number',
          ),
          keyboardType: TextInputType.number,
          validator: (value) =>
              value!.isEmpty ? 'Account number is required' : null,
        ),
      ],
    );
  }

  Widget _buildMobileBankingFields() {
    return Column(
      children: [
        TextFormField(
          controller: _serviceProviderController,
          decoration: const InputDecoration(
            labelText: 'Service Provider',
            hintText: 'e.g. bKash, Nagad, Rocket',
          ),
          validator: (value) =>
              value!.isEmpty ? 'Service provider is required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _mobileNumberController,
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            hintText: 'Enter your mobile number',
          ),
          keyboardType: TextInputType.phone,
          validator: (value) =>
              value!.isEmpty ? 'Mobile number is required' : null,
        ),
      ],
    );
  }

  Future<void> _requestWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final paymentMethod = _selectedPaymentMethod;

    // Prepare payment details based on selected method
    final Map<String, dynamic> paymentDetails = {};

    if (paymentMethod == 'Bank Transfer') {
      paymentDetails.addAll({
        'bank_name': _bankNameController.text,
        'account_name': _accountNameController.text,
        'account_number': _accountNumberController.text,
      });
    } else if (paymentMethod == 'Mobile Banking') {
      paymentDetails.addAll({
        'service_provider': _serviceProviderController.text,
        'mobile_number': _mobileNumberController.text,
      });
    }

    try {
      await ref
          .read(withdrawalProvider.notifier)
          .requestWithdrawal(amount, paymentMethod, paymentDetails);

      if (mounted) {
        SnackbarUtils.showSuccessSnackbar(
          context,
          'Withdrawal request submitted successfully',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showErrorSnackbar(context, e.toString());
      }
    }
  }
}
