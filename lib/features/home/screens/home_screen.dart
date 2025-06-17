// lib/features/home/screens/home_screen.dart
import 'package:app/core/enums/transaction_status.dart';
import 'package:app/core/enums/transaction_type.dart';
import 'package:app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Add this import
import '../../../app/theme.dart';
import '../providers/home_provider.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/income_chart_card.dart';
import '../widgets/referral_leaderboard_card.dart';
import '../widgets/tasks_progress_card.dart';
import '../widgets/todays_log_card.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../features/notifications/providers/notifications_provider.dart';
import '../../../models/user.dart'; // Add this import for the placeholder data

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final theme = Theme.of(context);
    final unreadCount =
        ref.watch(unreadNotificationsCountProvider).valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: homeState.when(
          data: (homeData) {
            final user = homeData['user'];
            return _buildUserHeader(user, theme);
          },
          loading: () => _buildUserHeader(
            _createPlaceholderUser(), // Create a placeholder user for skeleton
            theme,
          ),
          error: (_, __) => const Text('Investment Pro'),
        ),
        actions: [
          // Notification bell with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: theme.dividerColor,
                ),
                onPressed: () => context.push('/notifications'),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: () => ref.refresh(homeProvider.future),
        child: homeState.when(
          data: (homeData) {
            return _buildContent(context, homeData, false);
          },
          loading: () {
            // Create placeholder data for the skeleton UI
            final placeholderData = _createPlaceholderData();
            return _buildContent(context, placeholderData, true);
          },
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(homeProvider.future),
          ),
        ),
      ),
    );
  }

  // Helper method to build the user header
  Widget _buildUserHeader(User user, ThemeData theme) {
    return Row(
      children: [
        // Profile picture
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryColor, width: 2),
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF2A2A2A),
            backgroundImage: user.profilePicUrl != null
                ? NetworkImage(user.profilePicUrl!)
                : null,
            child: user.profilePicUrl == null
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),

        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.dividerColor,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.diamond,
                    color: AppTheme.primaryColor,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.isKycVerified ? 'Premium Member' : 'Standard Member',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build the main content
  Widget _buildContent(
    BuildContext context,
    Map<String, dynamic> data,
    bool isLoading,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      // Customize the shimmer effect if needed
      effect: ShimmerEffect(
        baseColor: const Color(0xFF2A2A2A),
        highlightColor: const Color(0xFF3A3A3A),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Balance Summary Card
              BalanceSummaryCard(
                user: data['user'],
                profitData: data['profitData'],
              ),
              const SizedBox(height: 20),

              // Action Buttons Row
              const ActionButtonsRow(),
              const SizedBox(height: 24),

              // Income Graph
              IncomeChartCard(profitData: data['profitData']),
              const SizedBox(height: 20),

              // Referral Leaderboard
              const ReferralLeaderboardCard(),
              const SizedBox(height: 20),

              // Today's Tasks
              const TasksProgressCard(),
              const SizedBox(height: 20),

              // Today's Log
              TodaysLogCard(transactions: data['recentTransactions']),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create placeholder user for skeleton UI
  User _createPlaceholderUser() {
    return User(
      id: 0,
      name: 'User Name',
      email: 'user@example.com',
      phone: '1234567890',
      balance: 1000.0,
      referralCode: 'REF123',
      planId: 1,
      isKycVerified: true,
      isAdmin: false,
      isBlocked: false,
      biometricEnabled: false,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  // Helper method to create placeholder data for skeleton UI
  Map<String, dynamic> _createPlaceholderData() {
    // Create placeholder profit data
    final profitData = List.generate(
      30,
      (index) => ProfitData(
        date: DateTime.now().subtract(Duration(days: index)),
        amount: 100.0,
      ),
    );

    // Create placeholder transactions
    final transactions = List.generate(
      5,
      (index) => Transaction(
        id: index,
        amount: 100.0,
        type: TransactionType.deposit,
        status: TransactionStatus.completed,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    return {
      'user': _createPlaceholderUser(),
      'profitData': profitData,
      'recentTransactions': transactions,
      // Add other placeholder data as needed
    };
  }
}
