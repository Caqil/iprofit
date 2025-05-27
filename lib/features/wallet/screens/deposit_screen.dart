import 'package:app/core/utils/validators.dart';
import 'package:app/features/wallet/providers/deposit_provider.dart';
import 'package:app/shared/widgets/custom_text_field.dart';
import 'package:app/shared/widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedMethod = 'manual';
  final _transactionIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final manualDepositState = ref.watch(manualDepositProvider);
    final coingateDepositState = ref.watch(coinGateDepositProvider);
    final uddoktapayDepositState = ref.watch(uddoktapayDepositProvider);

    bool isLoading =
        manualDepositState is AsyncLoading ||
        coingateDepositState is AsyncLoading ||
        uddoktapayDepositState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Deposit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _amountController,
                label: 'Amount',
                keyboardType: TextInputType.number,
                validator: Validators.validateAmount,
              ),
              const SizedBox(height: 16),

              // Method selector would go here
              if (_selectedMethod == 'manual') ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _transactionIdController,
                  label: 'Transaction ID',
                  validator: (value) =>
                      Validators.validateRequired(value, 'Transaction ID'),
                ),
                // Other sender information fields would go here
              ],

              const SizedBox(height: 24),
              LoadingButton(
                text: 'Submit Deposit',
                isLoading: isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final amount = double.parse(_amountController.text);

                      if (_selectedMethod == 'coingate') {
                        final result = await ref
                            .read(coinGateDepositProvider.notifier)
                            .deposit(amount);
                        // Handle redirect to payment gateway
                      } else if (_selectedMethod == 'uddoktapay') {
                        final result = await ref
                            .read(uddoktapayDepositProvider.notifier)
                            .deposit(amount);
                        // Handle redirect to payment gateway
                      } else {
                        // Manual deposit
                        await ref
                            .read(manualDepositProvider.notifier)
                            .deposit(
                              amount: amount,
                              transactionId: _transactionIdController.text,
                              paymentMethod:
                                  'Bank Transfer', // This would be selected by the user
                              senderInformation: {
                                'name': 'User Name',
                                // Other sender details would be collected from UI
                              },
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Deposit submitted successfully'),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
