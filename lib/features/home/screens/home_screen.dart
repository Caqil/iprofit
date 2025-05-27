// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/profit_chart.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transactions.dart';
import '../../../shared/widgets/error_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(homeProvider.future),
        child: homeState.when(
          data: (homeData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User greeting
                  Text(
                    'Hello, ${homeData['user'].name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome back to your investment dashboard',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Balance card
                  BalanceCard(
                    balance: homeData['user'].balance,
                    isKycVerified: homeData['user'].isKycVerified,
                  ),
                  const SizedBox(height: 24),

                  // Quick actions
                  const QuickActions(),
                  const SizedBox(height: 24),

                  // Profit chart
                  ProfitChart(profitData: homeData['profitData']),
                  const SizedBox(height: 24),

                  // Recent transactions
                  RecentTransactions(
                    transactions: homeData['recentTransactions'],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(homeProvider.future),
          ),
        ),
      ),
    );
  }
}
