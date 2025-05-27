// lib/shared/widgets/empty_state_widget.dart
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Factory constructors for common empty states
  factory EmptyStateWidget.noTransactions({VoidCallback? onButtonPressed}) {
    return EmptyStateWidget(
      icon: Icons.receipt_long,
      title: 'No Transactions Yet',
      message: 'Your transaction history will appear here.',
      buttonText: 'Make a Deposit',
      onButtonPressed: onButtonPressed,
    );
  }

  factory EmptyStateWidget.noNotifications() {
    return const EmptyStateWidget(
      icon: Icons.notifications_off,
      title: 'No Notifications',
      message: 'You don\'t have any notifications yet.',
    );
  }

  factory EmptyStateWidget.noReferrals({VoidCallback? onButtonPressed}) {
    return EmptyStateWidget(
      icon: Icons.people,
      title: 'No Referrals Yet',
      message: 'Invite your friends to earn referral bonuses.',
      buttonText: 'Share Referral Code',
      onButtonPressed: onButtonPressed,
    );
  }

  factory EmptyStateWidget.noTasks() {
    return const EmptyStateWidget(
      icon: Icons.task_alt,
      title: 'No Tasks Available',
      message: 'There are no tasks available for you at the moment.',
    );
  }

  factory EmptyStateWidget.noNews() {
    return const EmptyStateWidget(
      icon: Icons.newspaper,
      title: 'No News Available',
      message: 'Check back later for news and updates.',
    );
  }

  factory EmptyStateWidget.networkError({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'Network Error',
      message:
          'Could not connect to the server. Please check your internet connection.',
      buttonText: 'Retry',
      onButtonPressed: onRetry,
    );
  }
}
