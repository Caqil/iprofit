// lib/features/wallet/widgets/payment_method_card.dart
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? iconColor;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected ? BorderSide(color: color, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : null,
                onChanged: (_) => onTap(),
                activeColor: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Factory methods for common payment methods
  factory PaymentMethodCard.coingate({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return PaymentMethodCard(
      title: 'CoinGate (Crypto)',
      subtitle: 'Pay with Bitcoin, Ethereum, USDT, etc.',
      icon: Icons.currency_bitcoin,
      isSelected: isSelected,
      onTap: onTap,
      iconColor: Colors.orange,
    );
  }

  factory PaymentMethodCard.uddoktapay({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return PaymentMethodCard(
      title: 'UddoktaPay',
      subtitle: 'Pay with bKash, Nagad, Rocket, etc.',
      icon: Icons.mobile_friendly,
      isSelected: isSelected,
      onTap: onTap,
      iconColor: Colors.green,
    );
  }

  factory PaymentMethodCard.manual({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return PaymentMethodCard(
      title: 'Manual Payment',
      subtitle: 'Bank transfer, Mobile Banking, etc.',
      icon: Icons.account_balance,
      isSelected: isSelected,
      onTap: onTap,
      iconColor: Colors.blue,
    );
  }

  factory PaymentMethodCard.bankTransfer({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return PaymentMethodCard(
      title: 'Bank Transfer',
      subtitle: 'Transfer directly to bank account',
      icon: Icons.account_balance,
      isSelected: isSelected,
      onTap: onTap,
      iconColor: Colors.blue,
    );
  }

  factory PaymentMethodCard.mobileBanking({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return PaymentMethodCard(
      title: 'Mobile Banking',
      subtitle: 'bKash, Nagad, Rocket, etc.',
      icon: Icons.phone_android,
      isSelected: isSelected,
      onTap: onTap,
      iconColor: Colors.purple,
    );
  }
}
