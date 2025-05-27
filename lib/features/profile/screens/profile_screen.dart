// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/widgets/error_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileProvider.notifier).refresh(),
        child: profileState.when(
          data: (user) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile header
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Profile picture
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            backgroundImage: user.profilePicUrl != null
                                ? NetworkImage(user.profilePicUrl!)
                                : null,
                            child: user.profilePicUrl == null
                                ? Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: user.isKycVerified
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  user.isKycVerified
                                      ? Icons.verified_user
                                      : Icons.warning,
                                  size: 16,
                                  color: user.isKycVerified
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  user.isKycVerified
                                      ? 'Verified'
                                      : 'Unverified',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: user.isKycVerified
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () => context.push('/edit-profile'),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Settings sections
                  const Text(
                    'Account Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Account settings
                  _buildSettingsCard(context, [
                    _buildSettingsTile(
                      context,
                      'Change Password',
                      Icons.lock_outline,
                      () => context.push('/change-password'),
                    ),
                    if (!user.isKycVerified)
                      _buildSettingsTile(
                        context,
                        'KYC Verification',
                        Icons.verified_user_outlined,
                        () => context.push('/kyc'),
                      ),
                    _buildSettingsTile(
                      context,
                      'Biometric Login',
                      Icons.fingerprint,
                      () => _toggleBiometric(context, ref),
                      trailing: Switch(
                        value: user.biometricEnabled,
                        onChanged: (_) => _toggleBiometric(context, ref),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Wallet settings
                  const Text(
                    'Wallet & Investment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  _buildSettingsCard(context, [
                    _buildSettingsTile(
                      context,
                      'Investment Plans',
                      Icons.trending_up,
                      () => context.push('/plans'),
                    ),
                    _buildSettingsTile(
                      context,
                      'Transaction History',
                      Icons.history,
                      () => context.push('/transactions'),
                    ),
                    _buildSettingsTile(
                      context,
                      'Referrals',
                      Icons.people_outline,
                      () => context.push('/referrals'),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Other settings
                  const Text(
                    'Other',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  _buildSettingsCard(context, [
                    _buildSettingsTile(
                      context,
                      'News & Updates',
                      Icons.article_outlined,
                      () => context.push('/news'),
                    ),
                    _buildSettingsTile(
                      context,
                      'Help & Support',
                      Icons.help_outline,
                      () {
                        /* TODO: Navigate to support screen */
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      'About Us',
                      Icons.info_outline,
                      () {
                        /* TODO: Navigate to about screen */
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      'Log Out',
                      Icons.logout,
                      () => _showLogoutDialog(context, ref),
                      textColor: Colors.red,
                      iconColor: Colors.red,
                    ),
                  ]),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(profileProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> tiles) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: tiles),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _toggleBiometric(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(profileProvider.notifier).toggleBiometric();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(authProvider.notifier).logout();
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
