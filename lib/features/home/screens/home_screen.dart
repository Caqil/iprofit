// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../widgets/user_header_card.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/income_chart_card.dart';
import '../widgets/referral_leaderboard_card.dart';
import '../widgets/tasks_progress_card.dart';
import '../widgets/todays_log_card.dart';
import '../../../shared/widgets/error_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(homeProvider.future),
        child: homeState.when(
          data: (homeData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header with profile pic and welcome message
                  UserHeaderCard(user: homeData['user']),
                  const SizedBox(height: 20),

                  // Balance Summary Card
                  BalanceSummaryCard(
                    user: homeData['user'],
                    profitData: homeData['profitData'],
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons Row
                  const ActionButtonsRow(),
                  const SizedBox(height: 24),

                  // Income Graph
                  IncomeChartCard(profitData: homeData['profitData']),
                  const SizedBox(height: 20),

                  // Referral Leaderboard
                  const ReferralLeaderboardCard(),
                  const SizedBox(height: 20),

                  // Today's Tasks
                  const TasksProgressCard(),
                  const SizedBox(height: 20),

                  // Today's Log
                  TodaysLogCard(transactions: homeData['recentTransactions']),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
          ),
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(homeProvider.future),
          ),
        ),
      ),
    );
  }
}
