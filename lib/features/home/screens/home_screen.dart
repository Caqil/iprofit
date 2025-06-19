// lib/features/home/screens/home_screen.dart
import 'package:app/core/enums/transaction_status.dart';
import 'package:app/core/enums/transaction_type.dart';
import 'package:app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../app/theme.dart';
import '../providers/cached_home_provider.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/income_chart_card.dart';
import '../widgets/referral_leaderboard_card.dart';
import '../widgets/tasks_progress_card.dart';
import '../widgets/todays_log_card.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../features/notifications/providers/cached_notifications_provider.dart';
import '../../../models/user.dart';
import '../../../core/services/cache_service.dart' as cacheService;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    // Use synchronous provider for immediate cached data
    final syncCachedData = ref.watch(syncCachedHomeProvider);

    // Get user for header
    User? user;
    if (syncCachedData != null) {
      user = syncCachedData['user'] as User?;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: _buildUserHeader(user ?? _createPlaceholderUser(), theme),
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
        onRefresh: () async {
          // Refresh both home and notifications data
          await Future.wait([
            ref.read(cachedHomeProvider.notifier).refresh(),
            ref.read(cachedNotificationsProvider.notifier).refresh(),
          ]);
        },
        child: syncCachedData != null
            ? _buildInstantContent(context, ref, syncCachedData)
            : _buildAsyncContent(context, ref),
      ),
    );
  }

  // Show cached data INSTANTLY - no async operations!
  Widget _buildInstantContent(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> cachedData,
  ) {
    print('🚀 INSTANT: Showing cached data with NO loading state!');

    // Listen for background refresh errors
    ref.listen<AsyncValue<Map<String, dynamic>>>(cachedHomeProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, stack) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to refresh data'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () =>
                      ref.read(cachedHomeProvider.notifier).refresh(),
                ),
              ),
            );
          }
        },
      );
    });

    return _buildContent(context, cachedData, false); // NO skeleton!
  }

  // Handle first time users (no cache) with async provider
  Widget _buildAsyncContent(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(cachedHomeProvider);

    return homeState.when(
      data: (homeData) {
        print('🏠 Async: Data loaded');
        return _buildContent(context, homeData, false);
      },
      loading: () {
        print('💀 Async: Loading (first time)');
        final placeholderData = _createPlaceholderData();
        return _buildContent(context, placeholderData, true);
      },
      error: (error, stackTrace) {
        print('❌ Async: Error');
        return CustomErrorWidget(
          error: error.toString(),
          onRetry: () => ref.read(cachedHomeProvider.notifier).forceReload(),
        );
      },
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
      effect: const ShimmerEffect(
        baseColor: Color(0xFF2A2A2A),
        highlightColor: Color(0xFF3A3A3A),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Add cache status indicator (debug mode only)
              if (!isLoading) _buildCacheStatusIndicator(context),

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

  // Cache status indicator (for debugging)
  Widget _buildCacheStatusIndicator(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final cachedProvider = ref.read(cachedHomeProvider.notifier);
        final cacheInfo = cachedProvider.getCacheInfo();

        // Only show in debug mode
        if (!kDebugMode) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cached, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(
                'Data loaded from cache',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
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
