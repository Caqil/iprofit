// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../models/user.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/utils/navigation_utils.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: const Color(0xFF00D4AA),
        onRefresh: () => ref.refresh(profileProvider.future),
        child: profileState.when(
          data: (profileData) {
            return _buildContent(context, ref, profileData);
          },
          loading: () => _buildLoadingContent(),
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(profileProvider.future),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> data,
  ) {
    final user = data['user'] as User;
    final kycStatus = data['kycStatus'] as Map<String, dynamic>;
    final supportTickets = data['supportTickets'] as List<dynamic>;
    final appInfo = data['appInfo'] as Map<String, dynamic>;
    final accountSettings = data['accountSettings'] as Map<String, dynamic>;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Profile Header
          ProfileHeader(user: user),

          const SizedBox(height: 24),

          // Account Settings Section
          ProfileSection(
            title: 'Account Settings',
            children: [
              // KYC Verification
              ProfileMenuItem(
                icon: Icons.verified_user,
                title: 'KYC Verification',
                subtitle: _getKycStatusText(kycStatus),
                subtitleColor: _getKycStatusColor(kycStatus),
                trailing: _buildKycTrailing(context, ref, kycStatus),
                onTap: () => _handleKycTap(context, ref, kycStatus),
              ),

              // Biometric Login
              ProfileMenuItem(
                icon: Icons.fingerprint,
                title: 'Biometric Login',
                subtitle: accountSettings['biometric_enabled'] == true
                    ? 'Enabled'
                    : 'Disabled',
                subtitleColor: accountSettings['biometric_enabled'] == true
                    ? const Color(0xFF00D4AA)
                    : const Color(0xFF8E8E8E),
                trailing: Switch(
                  value: accountSettings['biometric_enabled'] == true,
                  onChanged: (value) => _toggleBiometric(context, ref, value),
                  activeColor: const Color(0xFF00D4AA),
                ),
              ),

              // Change Password
              ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () => context.push('/change-password'),
              ),

              // Logout
              ProfileMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                titleColor: const Color(0xFFFF6B6B),
                onTap: () => _showLogoutDialog(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Support & Info Section
          ProfileSection(
            title: 'Support & Info',
            children: [
              // Help & Support
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => _showHelpOptions(context),
              ),

              // My Tickets
              ProfileMenuItem(
                icon: Icons.confirmation_number_outlined,
                title: 'My Tickets',
                trailing: supportTickets.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D4AA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${supportTickets.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                onTap: () => _showSupportTickets(context),
              ),

              // App Info
              ProfileMenuItem(
                icon: Icons.info_outline,
                title: 'App Info',
                subtitle: appInfo['version'] ?? 'v2.1.3',
                onTap: () => _showAppInfo(context, appInfo),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Delete Account Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Color(0xFFFF6B6B), size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Permanently remove your account and all data',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _showDeleteAccountDialog(context, ref),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFF2A2A2A),
        highlightColor: Color(0xFF3A3A3A),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Header Skeleton
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).primaryColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Header with back button and edit button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 24, height: 24, color: Colors.white),
                          Container(width: 60, height: 18, color: Colors.white),
                          Container(width: 24, height: 24, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Profile content skeleton
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 160,
                                  height: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 140,
                                  height: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 100,
                                  height: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 80,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Account Settings Section Skeleton
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 140, height: 18, color: Colors.white),
                  const SizedBox(height: 12),
                  // Menu items skeleton
                  ...List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(width: 40, height: 40, color: Colors.white),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 80,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Container(width: 20, height: 20, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support & Info Section Skeleton
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 18, color: Colors.white),
                  const SizedBox(height: 12),
                  // Menu items skeleton
                  ...List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(width: 40, height: 40, color: Colors.white),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                if (index == 2) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 60,
                                    height: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Container(width: 20, height: 20, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper methods for KYC status
  String _getKycStatusText(Map<String, dynamic> kycStatus) {
    final status = kycStatus['status'] ?? 'not_submitted';
    final isVerified = kycStatus['is_verified'] == true;

    if (isVerified) return 'Approved';

    switch (status) {
      case 'pending':
        return 'Under Review';
      case 'rejected':
        return 'Rejected';
      case 'not_submitted':
      default:
        return 'Your account is not KYC verified';
    }
  }

  Color _getKycStatusColor(Map<String, dynamic> kycStatus) {
    final status = kycStatus['status'] ?? 'not_submitted';
    final isVerified = kycStatus['is_verified'] == true;

    if (isVerified) return const Color(0xFF00D4AA);

    switch (status) {
      case 'pending':
        return const Color(0xFFF1C40F);
      case 'rejected':
        return const Color(0xFFFF6B6B);
      case 'not_submitted':
      default:
        return const Color(0xFF8E8E8E);
    }
  }

  Widget? _buildKycTrailing(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> kycStatus,
  ) {
    final status = kycStatus['status'] ?? 'not_submitted';
    final isVerified = kycStatus['is_verified'] == true;

    if (isVerified) {
      return const Icon(Icons.check_circle, color: Color(0xFF00D4AA), size: 20);
    }

    if (status == 'not_submitted' || status == 'rejected') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1C40F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Verify Now',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return const Text(
      'View',
      style: TextStyle(
        color: Color(0xFF00D4AA),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Event handlers
  void _handleKycTap(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> kycStatus,
  ) {
    final status = kycStatus['status'] ?? 'not_submitted';
    final isVerified = kycStatus['is_verified'] == true;

    if (isVerified) {
      SnackbarUtils.showSuccessSnackbar(
        context,
        'Your account is already KYC verified',
      );
    } else {
      context.push('/kyc');
    }
  }

  void _toggleBiometric(BuildContext context, WidgetRef ref, bool value) async {
    try {
      await ref.read(profileProvider.notifier).updateBiometricSetting(value);
      SnackbarUtils.showSuccessSnackbar(
        context,
        value ? 'Biometric login enabled' : 'Biometric login disabled',
      );
    } catch (e) {
      SnackbarUtils.showErrorSnackbar(
        context,
        'Failed to update biometric setting',
      );
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Color(0xFF8E8E8E)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF8E8E8E)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Color(0xFFFF6B6B)),
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: TextStyle(color: Color(0xFF8E8E8E)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF8E8E8E)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(profileProvider.notifier).deleteAccount();
                if (context.mounted) {
                  SnackbarUtils.showSuccessSnackbar(
                    context,
                    'Account deleted successfully',
                  );
                  await ref.read(authProvider.notifier).logout();
                  context.go('/login');
                }
              } catch (e) {
                if (context.mounted) {
                  SnackbarUtils.showErrorSnackbar(
                    context,
                    'Failed to delete account',
                  );
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpOptions(BuildContext context) {
    NavigationUtils.showCustomBottomSheet(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF00D4AA)),
            title: const Text('Email Support'),
            onTap: () {
              Navigator.pop(context);
              // Open email app or copy email
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Color(0xFF00D4AA)),
            title: const Text('Live Chat'),
            onTap: () {
              Navigator.pop(context);
              // Open live chat
            },
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Color(0xFF00D4AA)),
            title: const Text('Create Ticket'),
            onTap: () {
              Navigator.pop(context);
              _showCreateTicketDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Create Support Ticket',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SnackbarUtils.showSuccessSnackbar(
                context,
                'Support ticket created successfully',
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSupportTickets(BuildContext context) {
    // Navigate to support tickets screen or show in bottom sheet
    SnackbarUtils.showInfoSnackbar(
      context,
      'Support tickets feature coming soon',
    );
  }

  void _showAppInfo(BuildContext context, Map<String, dynamic> appInfo) {
    NavigationUtils.showCustomBottomSheet(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Version'),
            trailing: Text(appInfo['version'] ?? 'v2.1.3'),
          ),
          ListTile(
            title: const Text('Build'),
            trailing: Text(appInfo['build'] ?? '123'),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
              // Open privacy policy
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
              // Open terms of service
            },
          ),
        ],
      ),
    );
  }
}
