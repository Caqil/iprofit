// lib/features/home/widgets/user_header_card.dart
import 'package:flutter/material.dart';
import '../../../models/user.dart';

class UserHeaderCard extends StatelessWidget {
  final User user;

  const UserHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          // Profile picture
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00D4AA), width: 2),
            ),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: const Color(0xFF2A2A2A),
              backgroundImage: user.profilePicUrl != null
                  ? NetworkImage(user.profilePicUrl!)
                  : null,
              child: user.profilePicUrl == null
                  ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Welcome text and user info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back',
                  style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.diamond,
                      color: Color(0xFF00D4AA),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.isKycVerified ? 'Premium Member' : 'Standard Member',
                      style: const TextStyle(
                        color: Color(0xFF00D4AA),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Notification bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
