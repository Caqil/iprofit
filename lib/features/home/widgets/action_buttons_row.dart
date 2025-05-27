// lib/features/home/widgets/action_buttons_row.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Deposit Button
        Expanded(
          child: _ActionButton(
            icon: Icons.add_circle_outline,
            label: 'Deposit',
            subtitle: 'Add funds',
            color: const Color(0xFF00D4AA),
            onTap: () => context.push('/deposit'),
          ),
        ),
        const SizedBox(width: 12),

        // Withdraw Button
        Expanded(
          child: _ActionButton(
            icon: Icons.arrow_circle_up_outlined,
            label: 'Withdraw',
            subtitle: 'Cash out',
            color: const Color(0xFF6366F1),
            onTap: () => context.push('/withdrawal'),
          ),
        ),
        const SizedBox(width: 12),

        // Buy Plan Button
        Expanded(
          child: _ActionButton(
            icon: Icons.shopping_cart_outlined,
            label: 'Buy Plan',
            subtitle: 'Upgrade',
            color: const Color(0xFF8B5CF6),
            onTap: () => context.push('/plans'),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),

            // Label
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),

            // Subtitle
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
