import 'package:app/core/utils/validators.dart';
import 'package:app/features/wallet/providers/withdrawal_provider.dart';
import 'package:app/shared/widgets/custom_text_field.dart';
import 'package:app/shared/widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Bank Transfer';
  final Map<String, dynamic> _paymentDetails = {};

  @override
  Widget build(BuildContext context) {
    final withdrawalRequestState = ref.watch(withdrawalRequestProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Request Withdrawal')),
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

              // Payment method selector and details fields would go here
              const SizedBox(height: 24),
              LoadingButton(
                text: 'Request Withdrawal',
                isLoading: withdrawalRequestState is AsyncLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await ref
                          .read(withdrawalRequestProvider.notifier)
                          .requestWithdrawal(
                            amount: double.parse(_amountController.text),
                            paymentMethod: _selectedPaymentMethod,
                            paymentDetails: _paymentDetails,
                          );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Withdrawal request submitted successfully',
                          ),
                        ),
                      );

                      Navigator.pop(context);
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
