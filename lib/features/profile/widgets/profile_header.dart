// lib/features/profile/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/user.dart';
import '../../../core/utils/formatters.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.scaffoldBackgroundColor,
            theme.primaryColor.withOpacity(0.1),
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
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/edit-profile'),
                    icon: const Icon(Icons.edit, color: Color(0xFF00D4AA)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Profile Avatar and Basic Info
              Row(
                children: [
                  // Avatar with verification badge
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00D4AA),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor: const Color(0xFF2A2A2A),
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
                      // Verification badge
                      if (user.isKycVerified)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00D4AA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name with verification badge
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (user.isKycVerified) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF00D4AA),
                                size: 20,
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Email
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),

                        // Phone
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              color: Color(0xFF8E8E8E),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                Formatters.formatPhoneNumber(user.phone),
                                style: const TextStyle(
                                  color: Color(0xFF8E8E8E),
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        // User ID
                        Row(
                          children: [
                            const Icon(
                              Icons.badge,
                              color: Color(0xFF8E8E8E),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'User ID: ${user.id}',
                              style: const TextStyle(
                                color: Color(0xFF8E8E8E),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Premium Plan Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: user.isKycVerified
                                ? const Color(0xFF00D4AA).withOpacity(0.2)
                                : const Color(0xFFF1C40F).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: user.isKycVerified
                                  ? const Color(0xFF00D4AA)
                                  : const Color(0xFFF1C40F),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                user.isKycVerified
                                    ? Icons.diamond
                                    : Icons.star_border,
                                color: user.isKycVerified
                                    ? const Color(0xFF00D4AA)
                                    : const Color(0xFFF1C40F),
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.isKycVerified
                                    ? 'Premium Plan'
                                    : 'Basic Plan',
                                style: TextStyle(
                                  color: user.isKycVerified
                                      ? const Color(0xFF00D4AA)
                                      : const Color(0xFFF1C40F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
