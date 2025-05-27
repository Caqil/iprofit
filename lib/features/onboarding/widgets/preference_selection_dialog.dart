// lib/features/onboarding/widgets/preference_selection_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/global_providers.dart';

class PreferenceSelectionDialog extends ConsumerStatefulWidget {
  const PreferenceSelectionDialog({super.key});

  @override
  ConsumerState<PreferenceSelectionDialog> createState() =>
      _PreferenceSelectionDialogState();
}

class _PreferenceSelectionDialogState
    extends ConsumerState<PreferenceSelectionDialog> {
  // User preferences state
  List<String> selectedInvestmentTypes = [];
  double riskTolerance = 2.0; // Medium risk by default (1-3 scale)
  String selectedCurrency = 'USD'; // Default currency

  final List<Map<String, dynamic>> investmentTypes = [
    {'id': 'stocks', 'name': 'Stocks', 'icon': Icons.trending_up},
    {'id': 'crypto', 'name': 'Cryptocurrency', 'icon': Icons.currency_bitcoin},
    {'id': 'forex', 'name': 'Forex', 'icon': Icons.currency_exchange},
    {'id': 'realestate', 'name': 'Real Estate', 'icon': Icons.home},
    {'id': 'commodities', 'name': 'Commodities', 'icon': Icons.diamond},
  ];

  final List<Map<String, dynamic>> currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
    {'code': 'BTC', 'name': 'Bitcoin', 'symbol': '₿'},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Customize Your Experience',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help us personalize your investment journey by selecting your preferences.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Investment types selection
              const Text(
                'What investments are you interested in?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: investmentTypes.map((type) {
                  final isSelected = selectedInvestmentTypes.contains(
                    type['id'],
                  );
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedInvestmentTypes.remove(type['id']);
                        } else {
                          selectedInvestmentTypes.add(type['id']);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type['icon'],
                            color: isSelected ? Colors.white : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Risk tolerance slider
              const Text(
                'What is your risk tolerance?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Slider(
                value: riskTolerance,
                min: 1,
                max: 3,
                divisions: 2,
                label: riskTolerance == 1
                    ? 'Low'
                    : riskTolerance == 2
                    ? 'Medium'
                    : 'High',
                onChanged: (value) {
                  setState(() {
                    riskTolerance = value;
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Low Risk', style: TextStyle(fontSize: 12)),
                  Text('Medium Risk', style: TextStyle(fontSize: 12)),
                  Text('High Risk', style: TextStyle(fontSize: 12)),
                ],
              ),

              const SizedBox(height: 24),

              // Preferred currency
              const Text(
                'Preferred Currency',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedCurrency,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: currencies.map((currency) {
                  return DropdownMenuItem<String>(
                    value: currency['code'],
                    child: Row(
                      children: [
                        Text(currency['symbol']),
                        const SizedBox(width: 8),
                        Text('${currency['code']} - ${currency['name']}'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCurrency = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 32),

              // Save preferences button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // Save preferences to storage
                    final storageService = ref.read(storageServiceProvider);
                    await storageService.saveObject('user_preferences', {
                      'investment_types': selectedInvestmentTypes,
                      'risk_tolerance': riskTolerance,
                      'currency': selectedCurrency,
                    });

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Continue', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
