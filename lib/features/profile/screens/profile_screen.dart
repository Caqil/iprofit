// lib/features/profile/screens/profile_screen.dart
// EXACT MATCH FOR THE UI IN THE IMAGE WITH SKELETON LOADING
// Features: Skeletonizer for loading states, matches exact design from image

import 'package:app/shared/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/profile_provider.dart';
import '../../../models/user.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1A1A1A),

      body: RefreshIndicator(
        color: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFF2A2A2A),
        onRefresh: () async {
          ref.invalidate(profileProvider);
          await ref.read(profileProvider.future);
        },
        child: profileState.when(
          data: (user) => _buildContent(context, ref, user, false),
          loading: () =>
              _buildContent(context, ref, _createPlaceholderUser(), true),
          error: (error, stackTrace) =>
              _buildErrorContent(context, ref, error.toString()),
        ),
      ),
    );
  }

  // Helper method to create placeholder user for skeleton UI
  User _createPlaceholderUser() {
    return User(
      id: 982345,
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 234 567 8901',
      balance: 1000.0,
      referralCode: 'REF123',
      planId: 1,
      isKycVerified: true,
      isAdmin: false,
      isBlocked: false,
      biometricEnabled: true,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    User user,
    bool isLoading,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      effect: const ShimmerEffect(
        baseColor: Color(0xFF2A2A2A),
        highlightColor: Color(0xFF3A3A3A),
        duration: Duration(milliseconds: 1000),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            _buildProfileHeader(context, user),
            // Account Settings Section
            _buildAccountSettingsSection(context, ref, user),
            // Support & Info Section
            _buildSupportInfoSection(context),
            // Delete Account Section
            _buildDeleteAccountSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return GlassContainer(
      glassType: GlassType.dark,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          // Profile Picture and Name Row
          Row(
            children: [
              // Profile Picture
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3B82F6), width: 2),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF4A5568),
                  backgroundImage: user.profilePicUrl != null
                      ? NetworkImage(user.profilePicUrl!)
                      : null,
                  child: user.profilePicUrl == null
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(width: 16),

              // Name and Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with verified badge
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (user.isKycVerified)
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Email
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),

              // Edit Icon
              IconButton(
                onPressed: () => context.push('/edit-profile'),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Phone Number Row
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF3B82F6), size: 16),
              const SizedBox(width: 8),
              Skeletonizer.zone(
                child: Text(
                  user.phone.isNotEmpty ? user.phone : '+1 234 567 8901',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // User ID Row
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: Color(0xFF3B82F6),
                size: 16,
              ),
              const SizedBox(width: 8),
              Skeletonizer.zone(
                child: Text(
                  'User ID: ${user.id}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Premium Plan Badge
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Premium Plan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettingsSection(
    BuildContext context,
    WidgetRef ref,
    User user,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Skeletonizer.zone(
            child: const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Settings Container
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Column(
            children: [
              // KYC Verification (Approved)
              if (user.isKycVerified) ...[
                _buildSettingsItem(
                  icon: Icons.check_circle,
                  iconColor: const Color(0xFF10B981),
                  title: 'KYC Verification',
                  subtitle: 'Approved',
                  subtitleColor: const Color(0xFF10B981),
                  trailing: _buildActionButton(
                    'View',
                    color: const Color(0xFF3B82F6),
                    onPressed: () => context.push('/kyc'),
                  ),
                ),
                _buildDivider(),
              ],

              // KYC Not Verified
              if (!user.isKycVerified) ...[
                _buildSettingsItem(
                  icon: Icons.warning,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'KYC Not Verified',
                  subtitle: 'Your account is not KYC verified',
                  subtitleColor: const Color(0xFFF59E0B),
                  trailing: _buildActionButton(
                    'Verify',
                    color: const Color(0xFFF59E0B),
                    onPressed: () => context.push('/kyc'),
                  ),
                ),
                _buildDivider(),
              ],

              // Biometric Login
              _buildSettingsItem(
                icon: Icons.fingerprint,
                iconColor: const Color(0xFF3B82F6),
                title: 'Biometric Login',
                trailing: Switch(
                  value: user.biometricEnabled,
                  onChanged: (value) => _toggleBiometric(context, ref, value),
                  activeColor: const Color(0xFF3B82F6),
                  activeTrackColor: const Color(0xFF3B82F6).withOpacity(0.3),
                  inactiveThumbColor: const Color(0xFF6B7280),
                  inactiveTrackColor: const Color(0xFF374151),
                ),
              ),

              _buildDivider(),

              // Change Password
              _buildSettingsItem(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF3B82F6),
                title: 'Change Password',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
                onTap: () => context.push('/change-password'),
              ),

              _buildDivider(),

              // Logout
              _buildSettingsItem(
                icon: Icons.logout,
                iconColor: const Color(0xFFEF4444),
                title: 'Logout',
                titleColor: const Color(0xFFEF4444),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
                onTap: () => _showLogoutDialog(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Skeletonizer.zone(
            child: const Text(
              'Support & Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Support Container
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Column(
            children: [
              // Help & Support
              _buildSettingsItem(
                icon: Icons.help_outline,
                iconColor: const Color(0xFF3B82F6),
                title: 'Help & Support',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
                onTap: () => _showHelpOptions(context),
              ),

              _buildDivider(),

              // My Tickets
              _buildSettingsItem(
                icon: Icons.confirmation_number_outlined,
                iconColor: const Color(0xFF3B82F6),
                title: 'My Tickets',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Notification Badge
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ],
                ),
                onTap: () => _showSupportTickets(context),
              ),

              _buildDivider(),

              // App Info
              _buildSettingsItem(
                icon: Icons.info_outline,
                iconColor: const Color(0xFF3B82F6),
                title: 'App Info',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'v2.1.3',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ],
                ),
                onTap: () => _showAppInfo(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountSection(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_outlined,
            color: Color(0xFFEF4444),
            size: 24,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Permanently remove your account and all data',
                  style: TextStyle(fontSize: 12, color: Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
          _buildActionButton(
            'Delete',
            color: const Color(0xFFEF4444),
            onPressed: () => _showDeleteAccountDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer.zone(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: titleColor ?? Colors.white,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Skeletonizer.zone(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: subtitleColor ?? const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text, {
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 56),
      color: const Color(0xFF3A3A3A),
    );
  }

  Widget _buildErrorContent(BuildContext context, WidgetRef ref, String error) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFEF4444),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(profileProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  Future<void> _toggleBiometric(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    try {
      await ref.read(profileProvider.notifier).toggleBiometric(value);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value
                  ? 'Biometric authentication enabled'
                  : 'Biometric authentication disabled',
            ),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
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
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.chat, color: Color(0xFF3B82F6)),
              title: const Text(
                'Live Chat',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xFF3B82F6)),
              title: const Text(
                'Email Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showSupportTickets(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support tickets feature coming soon')),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'App Information',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: v2.1.3', style: TextStyle(color: Colors.white)),
            Text('Build: 123', style: TextStyle(color: Colors.white)),
            Text(
              'Support: support@example.com',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF3B82F6))),
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
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteAccount(context, ref);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteAccount(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(profileProvider.notifier).deleteAccount();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }
}
