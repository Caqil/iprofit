// lib/features/referrals/screens/referrals_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/referrals_provider.dart';
import '../../../models/referral.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../app/theme.dart';

class ReferralsScreen extends ConsumerStatefulWidget {
  const ReferralsScreen({super.key});

  @override
  ConsumerState<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends ConsumerState<ReferralsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  late AnimationController _shimmerAnimationController;
  late AnimationController _progressAnimationController;

  late Animation<double> _slideAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shimmerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_shimmerAnimationController);
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _slideAnimationController.forward();
    _shimmerAnimationController.repeat();
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _shimmerAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final referralInfoState = ref.watch(referralInfoProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Refer & Earn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A1A),
              AppTheme.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: RefreshIndicator(
          color: AppTheme.primaryColor,
          backgroundColor: const Color(0xFF2A2A2A),
          onRefresh: () => ref.read(referralInfoProvider.notifier).refresh(),
          child: referralInfoState.when(
            data: (referralInfo) => _buildContent(referralInfo, false),
            loading: () => _buildContent(_getMockData(), true),
            error: (error, stackTrace) => _buildErrorContent(error.toString()),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> referralInfo, bool isLoading) {
    final referrals = referralInfo['referrals'] as List<Referral>;
    final totalReferrals = referralInfo['total_referrals'] as int;
    final totalEarnings = referralInfo['total_earnings'] as double;
    final referralCode = referralInfo['referral_code'] as String;

    return Skeletonizer(
      enabled: isLoading,
      effect: const ShimmerEffect(
        baseColor: Color(0xFF2A2A2A),
        highlightColor: Color(0xFF3A3A3A),
        duration: Duration(milliseconds: 1000),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _slideAnimation.value)),
              child: Opacity(
                opacity: _slideAnimation.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero section
                    _buildHeroSection(totalReferrals),

                    const SizedBox(height: 24),

                    // Referral Code section
                    _buildReferralCodeSection(referralCode),

                    const SizedBox(height: 24),

                    // Stats section
                    _buildStatsSection(totalReferrals, totalEarnings),

                    const SizedBox(height: 24),

                    // Rank progress section
                    _buildRankSection(totalReferrals),

                    const SizedBox(height: 24),

                    // Recent earnings
                    _buildRecentEarnings(referrals),

                    const SizedBox(height: 24),

                    // Referral network
                    _buildReferralNetwork(referrals),

                    const SizedBox(height: 100), // Bottom padding for safe area
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroSection(int totalReferrals) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return GlassContainer(
          glassType: GlassType.primary,
          shadowType: ShadowType.glow,
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.primaryColor.withOpacity(0.05),
            ],
          ),
          child: Stack(
            children: [
              // Shimmer effect overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment(-1.0 + _shimmerAnimation.value * 2, 0.0),
                      end: Alignment(1.0 + _shimmerAnimation.value * 2, 0.0),
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Earn from Your Network',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Invite friends & earn 5% of their profits forever!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Conditional user avatars row or empty state
                  if (totalReferrals > 0) ...[
                    Row(
                      children: [
                        // Show up to 4 avatars, but only if we have referrals
                        ...List.generate(
                          totalReferrals < 4 ? totalReferrals : 4,
                          (index) => Padding(
                            padding: EdgeInsets.only(left: index * 12.0),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.2),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            totalReferrals == 1
                                ? '1 user joined through referrals'
                                : '+${totalReferrals} users joined through referrals',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Empty state when no referrals
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_add_outlined,
                            color: Colors.white60,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Start inviting friends to build your network',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReferralCodeSection(String referralCode) {
    return GlassContainer(
      glassType: GlassType.secondary,
      shadowType: ShadowType.medium,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_giftcard, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Your Referral Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Referral code display
          GlassContainer(
            glassType: GlassType.dark,
            shadowType: ShadowType.soft,
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Copy',
                  Icons.copy,
                  () => _copyReferralCode(referralCode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'QR',
                  Icons.qr_code,
                  () => _showQRCode(referralCode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Share',
                  Icons.share,
                  () => _shareReferralCode(referralCode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GlassContainer(
      glassType: GlassType.primary,
      shadowType: ShadowType.soft,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(int totalReferrals, double totalEarnings) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Referred Users',
            totalReferrals.toString(),
            Icons.people,
            '+3 this month',
            AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Earned',
            Formatters.formatCurrency(totalEarnings),
            Icons.monetization_on,
            '+₹25 this month',
            const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    String subtitle,
    Color accentColor,
  ) {
    return GlassContainer(
      glassType: GlassType.dark,
      shadowType: ShadowType.soft,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      border: Border.all(color: accentColor.withOpacity(0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'New',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: accentColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankSection(int totalReferrals) {
    final progress = (totalReferrals / 500).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return GlassContainer(
          glassType: GlassType.accent,
          shadowType: ShadowType.glow,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF8B5CF6).withOpacity(0.1),
              const Color(0xFF3B82F6).withOpacity(0.1),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.diamond,
                      color: Color(0xFF8B5CF6),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT: PLATINUM',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Rank Up to Diamond',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Refer 500 person to reach your next rank.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress * _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${totalReferrals}/500',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentEarnings(List<Referral> referrals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Earnings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showAllEarnings(),
              child: const Text(
                'View All',
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Sample earnings items
        ..._buildEarningItems(),
      ],
    );
  }

  List<Widget> _buildEarningItems() {
    final earnings = [
      {
        'name': 'Hasan',
        'amount': '₹10',
        'time': 'Today, 09:45 AM',
        'type': 'Profit',
      },
      {
        'name': 'Fatima',
        'amount': '₹25',
        'time': 'Yesterday, 02:30 PM',
        'type': 'Profit',
      },
      {
        'name': 'Rafi',
        'amount': 'New',
        'time': 'Just joined now',
        'type': 'Join',
      },
    ];

    return earnings
        .map(
          (earning) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassContainer(
              glassType: GlassType.secondary,
              shadowType: ShadowType.soft,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      earning['name']![0],
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earned ${earning['amount']} from ${earning['name']}\'s ${earning['type']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          earning['time']!,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: earning['type'] == 'Join'
                          ? AppTheme.primaryColor.withOpacity(0.2)
                          : const Color(0xFF10B981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      earning['amount']!,
                      style: TextStyle(
                        color: earning['type'] == 'Join'
                            ? AppTheme.primaryColor
                            : const Color(0xFF10B981),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildReferralNetwork(List<Referral> referrals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Referral Network',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        if (referrals.isEmpty)
          _buildEmptyNetworkState()
        else
          ...referrals
              .take(5)
              .map((referral) => _buildReferralNetworkItem(referral)),
      ],
    );
  }

  Widget _buildReferralNetworkItem(Referral referral) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassContainer(
        glassType: GlassType.dark,
        shadowType: ShadowType.soft,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              child: Text(
                referral.name.isNotEmpty ? referral.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    referral.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Joined ${Formatters.formatDate(referral.createdAt)}',
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: referral.isActive
                    ? const Color(0xFF10B981).withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                referral.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: referral.isActive
                      ? const Color(0xFF10B981)
                      : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyNetworkState() {
    return GlassContainer(
      glassType: GlassType.secondary,
      shadowType: ShadowType.soft,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(32),
      child: const Column(
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.white30),
          SizedBox(height: 16),
          Text(
            'No referrals yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Share your referral code to start building your network',
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: GlassContainer(
          glassType: GlassType.error,
          shadowType: ShadowType.colored,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(referralInfoProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getMockData() {
    return {
      'referrals': <Referral>[],
      'total_referrals': 24,
      'total_earnings': 1458.0,
      'referral_code': 'INVEST589',
    };
  }

  void _copyReferralCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    SnackbarUtils.showSuccessSnackbar(
      context,
      'Referral code copied to clipboard',
    );
  }

  void _shareReferralCode(String code) {
    // Implement share functionality
    ref.read(referralInfoProvider.notifier).shareReferralCode(code);
  }

  void _showQRCode(String code) {
    // Implement QR code dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('QR Code', style: TextStyle(color: Colors.white)),
        content: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'QR Code\nWould be here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'How Referrals Work',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Share your referral code with friends\n'
              '• When they sign up and start investing\n'
              '• You earn 5% of their profits forever\n'
              '• Climb ranks to unlock more benefits',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllEarnings() {
    // Navigate to detailed earnings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('View all earnings - feature coming soon'),
        backgroundColor: Color(0xFF2A2A2A),
      ),
    );
  }
}
