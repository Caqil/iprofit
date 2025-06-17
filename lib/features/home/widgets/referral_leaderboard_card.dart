// lib/features/home/widgets/referral_leaderboard_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../providers/home_provider.dart';

class ReferralLeaderboardCard extends ConsumerWidget {
  const ReferralLeaderboardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return homeState.when(
      data: (homeData) {
        final referralLeaderboard =
            homeData['referralLeaderboard'] as List<ReferralLeaderboardItem>;

        return _buildLeaderboard(context, referralLeaderboard);
      },
      loading: () => _buildLoadingState(),
      error: (_, __) => _buildErrorState(),
    );
  }

  Widget _buildLeaderboard(
    BuildContext context,
    List<ReferralLeaderboardItem> leaderboard,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.canvasColor, theme.primaryColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.disabledColor.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.leaderboard,
                      color: Color(0xFF6366F1),
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Referral Leaderboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/referrals'),
                child: const Text(
                  'See More',
                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Leaderboard items or empty state
          if (leaderboard.isEmpty)
            _buildEmptyState()
          else
            ...leaderboard.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _LeaderboardItem(
                name: item.name,
                referrals:
                    '${item.referralCount} Referral${item.referralCount != 1 ? 's' : ''}',
                amount: '+\$${item.earnings.toStringAsFixed(0)}',
                avatar: item.avatar,
                rank: index + 1,
                isCurrentUser: item.isCurrentUser,
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.people_outline, color: Color(0xFF8E8E8E), size: 48),
            SizedBox(height: 12),
            Text(
              'No referrals yet',
              style: TextStyle(
                color: Color(0xFF8E8E8E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Start referring friends to see the leaderboard',
              style: TextStyle(color: Color(0xFF666666), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      height: 200,
      child: const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      height: 200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Color(0xFF8E8E8E), size: 48),
            SizedBox(height: 12),
            Text(
              'Error loading leaderboard',
              style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final String name;
  final String referrals;
  final String amount;
  final String avatar;
  final int rank;
  final bool isCurrentUser;

  const _LeaderboardItem({
    required this.name,
    required this.referrals,
    required this.amount,
    required this.avatar,
    required this.rank,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    Color getRankColor() {
      switch (rank) {
        case 1:
          return const Color(0xFFFFD700); // Gold
        case 2:
          return const Color(0xFFC0C0C0); // Silver
        case 3:
          return const Color(0xFFCD7F32); // Bronze
        default:
          return const Color(0xFF8E8E8E);
      }
    }

    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.canvasColor, theme.primaryColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.disabledColor.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: getRankColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: getRankColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentUser
                    ? AppTheme.primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name and referrals
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isCurrentUser ? AppTheme.primaryColor : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  referrals,
                  style: const TextStyle(
                    color: Color(0xFF8E8E8E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
