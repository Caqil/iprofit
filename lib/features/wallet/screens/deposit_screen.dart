// lib/features/wallet/screens/deposit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wallet_provider.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/enums/payment_gateway.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  PaymentGateway _selectedGateway = PaymentGateway.coingate;

  // For manual payment
  final _transactionIdController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    _paymentMethodController.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    super.dispose();
  }

  Future<void> _processDeposit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    try {
      Map<String, dynamic> result;

      switch (_selectedGateway) {
        case PaymentGateway.coingate:
          result = await ref
              .read(depositProvider.notifier)
              .depositViaCoingate(amount);
          _openPaymentWebView(result['payment_url']);
          break;

        case PaymentGateway.uddoktapay:
          result = await ref
              .read(depositProvider.notifier)
              .depositViaUddoktapay(amount);
          _openPaymentWebView(result['payment_url']);
          break;

        case PaymentGateway.manual:
          final senderInfo = {
            'name': _senderNameController.text,
            'phone': _senderPhoneController.text,
          };

          result = await ref
              .read(depositProvider.notifier)
              .depositViaManual(
                amount,
                _transactionIdController.text,
                _paymentMethodController.text,
                senderInfo,
              );

          if (mounted) {
            SnackbarUtils.showSuccessSnackbar(
              context,
              'Manual deposit submitted successfully. It will be reviewed by admin.',
            );
            Navigator.pop(context);
          }
          break;
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showErrorSnackbar(context, e.toString());
      }
    }
  }

  void _openPaymentWebView(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Complete Payment')),
          body: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(url)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final depositState = ref.watch(depositProvider);
    final isLoading = depositState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Deposit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Payment method selection
              Card(
                child: Column(
                  children: [
                    RadioListTile<PaymentGateway>(
                      title: const Text('CoinGate (Crypto)'),
                      subtitle: const Text('Pay with Bitcoin, Ethereum, etc.'),
                      value: PaymentGateway.coingate,
                      groupValue: _selectedGateway,
                      onChanged: (value) {
                        setState(() {
                          _selectedGateway = value!;
                        });
                      },
                    ),
                    RadioListTile<PaymentGateway>(
                      title: const Text('UddoktaPay'),
                      subtitle: const Text(
                        'Pay with bKash, Nagad, Rocket, etc.',
                      ),
                      value: PaymentGateway.uddoktapay,
                      groupValue: _selectedGateway,
                      onChanged: (value) {
                        setState(() {
                          _selectedGateway = value!;
                        });
                      },
                    ),
                    RadioListTile<PaymentGateway>(
                      title: const Text('Manual Payment'),
                      subtitle: const Text(
                        'Bank transfer, Mobile Banking, etc.',
                      ),
                      value: PaymentGateway.manual,
                      groupValue: _selectedGateway,
                      onChanged: (value) {
                        setState(() {
                          _selectedGateway = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Amount field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter deposit amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validateAmount,
              ),

              // Manual payment fields
              if (_selectedGateway == PaymentGateway.manual) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _transactionIdController,
                  decoration: const InputDecoration(
                    labelText: 'Transaction ID',
                    hintText: 'Enter transaction ID',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Transaction ID is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _paymentMethodController,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    hintText: 'e.g. bKash, Nagad, Bank Transfer',
                    prefixIcon: Icon(Icons.payment),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Payment method is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senderNameController,
                  decoration: const InputDecoration(
                    labelText: 'Sender Name',
                    hintText: 'Enter sender name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Sender name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senderPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Sender Phone',
                    hintText: 'Enter sender phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Sender phone is required' : null,
                ),
              ],

              const SizedBox(height: 32),

              // Deposit button
              SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  onPressed: _processDeposit,
                  text: 'Deposit',
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
