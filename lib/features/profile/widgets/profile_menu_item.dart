// lib/features/profile/widgets/profile_menu_item.dart
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Color? subtitleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showArrow;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.subtitleColor,
    this.trailing,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: _getIconColor(),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 16),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor ?? Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: subtitleColor ?? const Color(0xFF8E8E8E),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing widget or arrow
                if (trailing != null)
                  trailing!
                else if (showArrow && onTap != null)
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF8E8E8E),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconColor() {
    switch (icon) {
      case Icons.verified_user:
        return const Color(0xFF00D4AA);
      case Icons.fingerprint:
        return const Color(0xFF6366F1);
      case Icons.lock_outline:
        return const Color(0xFF8B5CF6);
      case Icons.logout:
        return const Color(0xFFFF6B6B);
      case Icons.help_outline:
        return const Color(0xFF00D4AA);
      case Icons.confirmation_number_outlined:
        return const Color(0xFF6366F1);
      case Icons.info_outline:
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF8E8E8E);
    }
  }

  Color _getIconBackgroundColor() {
    switch (icon) {
      case Icons.verified_user:
        return const Color(0xFF00D4AA).withOpacity(0.15);
      case Icons.fingerprint:
        return const Color(0xFF6366F1).withOpacity(0.15);
      case Icons.lock_outline:
        return const Color(0xFF8B5CF6).withOpacity(0.15);
      case Icons.logout:
        return const Color(0xFFFF6B6B).withOpacity(0.15);
      case Icons.help_outline:
        return const Color(0xFF00D4AA).withOpacity(0.15);
      case Icons.confirmation_number_outlined:
        return const Color(0xFF6366F1).withOpacity(0.15);
      case Icons.info_outline:
        return const Color(0xFF8B5CF6).withOpacity(0.15);
      default:
        return const Color(0xFF8E8E8E).withOpacity(0.15);
    }
  }
}