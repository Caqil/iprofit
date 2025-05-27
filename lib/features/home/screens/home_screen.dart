// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import '../providers/home_provider.dart';
import '../widgets/user_header_card.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/income_chart_card.dart';
import '../widgets/referral_leaderboard_card.dart';
import '../widgets/tasks_progress_card.dart';
import '../widgets/todays_log_card.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../features/notifications/providers/notifications_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _scrollController = ScrollController();
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final showElevation = _scrollController.offset > 0;
    if (showElevation != _showElevation) {
      setState(() {
        _showElevation = showElevation;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final unreadCount =
        ref.watch(unreadNotificationsCountProvider).valueOrNull ?? 0;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
        backgroundColor: _showElevation
            ? const Color(0xFF2A2A2A).withOpacity(0.8)
            : Colors.transparent,
        flexibleSpace: _showElevation
            ? ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),
              )
            : null,
        title: _showElevation
            ? const Text(
                'Investment Pro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        actions: [
          // Notification bell with badge
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3A3A3A),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => context.push('/notifications'),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4AA),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF00D4AA),
        onRefresh: () => ref.refresh(homeProvider.future),
        child: homeState.when(
          data: (homeData) {
            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(
                              0.0,
                              0.5,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(
                            0.0,
                            0.5,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0),
                        child: UserHeaderCard(user: homeData['user']),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _buildAnimatedCard(
                      BalanceSummaryCard(
                        user: homeData['user'],
                        profitData: homeData['profitData'],
                      ),
                      0.1,
                    ),
                    const SizedBox(height: 20),
                    _buildAnimatedCard(const ActionButtonsRow(), 0.2),
                    const SizedBox(height: 24),
                    _buildAnimatedCard(
                      IncomeChartCard(profitData: homeData['profitData']),
                      0.3,
                    ),
                    const SizedBox(height: 20),
                    _buildAnimatedCard(const ReferralLeaderboardCard(), 0.4),
                    const SizedBox(height: 20),
                    _buildAnimatedCard(const TasksProgressCard(), 0.5),
                    const SizedBox(height: 20),
                    _buildAnimatedCard(
                      TodaysLogCard(
                        transactions: homeData['recentTransactions'],
                      ),
                      0.6,
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ],
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

  Widget _buildAnimatedCard(Widget child, double delay) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(delay, delay + 0.4, curve: Curves.easeOutCubic),
              ),
            ),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(delay, delay + 0.4, curve: Curves.easeOutCubic),
            ),
          ),
          child: GlassmorphicCard(child: child),
        ),
      ),
    );
  }
}

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF3A3A3A).withOpacity(0.5),
                  const Color(0xFF2A2A2A).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
