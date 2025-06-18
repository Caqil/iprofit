// lib/core/widgets/glass_container.dart
import 'package:flutter/material.dart';
import 'dart:ui';

enum GlassType {
  primary, // Blue glass effect
  secondary, // White glass effect
  accent, // Gradient glass effect
  success, // Green glass effect
  warning, // Orange/Yellow glass effect
  error, // Red glass effect
  dark, // Dark glass effect
  light, // Light glass effect
}

enum ShadowType { none, soft, medium, hard, glow, colored }

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final GlassType glassType;
  final ShadowType shadowType;
  final Color? customGlassColor;
  final Color? customShadowColor;
  final double? blur;
  final double? opacity;
  final Gradient? gradient;
  final Border? border;
  final VoidCallback? onTap;
  final bool enableHoverEffect;
  final bool enablePressEffect;
  final Duration animationDuration;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.glassType = GlassType.primary,
    this.shadowType = ShadowType.soft,
    this.customGlassColor,
    this.customShadowColor,
    this.blur,
    this.opacity,
    this.gradient,
    this.border,
    this.onTap,
    this.enableHoverEffect = true,
    this.enablePressEffect = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        width: width,
        height: height,
        margin: margin,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blur ?? _getDefaultBlur(),
              sigmaY: blur ?? _getDefaultBlur(),
            ),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: _getGlassColor(context),
                gradient: gradient,
                borderRadius: borderRadius ?? BorderRadius.circular(16),
                border: border ?? _getDefaultBorder(),
                boxShadow: _getShadows(),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Color _getGlassColor(BuildContext context) {
    if (customGlassColor != null) {
      return customGlassColor!.withOpacity(opacity ?? 0.1);
    }

    switch (glassType) {
      case GlassType.primary:
        return const Color(0xFF3B82F6).withOpacity(opacity ?? 0.1);
      case GlassType.secondary:
        return Colors.white.withOpacity(opacity ?? 0.05);
      case GlassType.accent:
        return const Color(0xFF8B5CF6).withOpacity(opacity ?? 0.1);
      case GlassType.success:
        return const Color(0xFF10B981).withOpacity(opacity ?? 0.1);
      case GlassType.warning:
        return const Color(0xFFF59E0B).withOpacity(opacity ?? 0.1);
      case GlassType.error:
        return const Color(0xFFEF4444).withOpacity(opacity ?? 0.1);
      case GlassType.dark:
        return const Color(0xFF1F2937).withOpacity(opacity ?? 0.3);
      case GlassType.light:
        return Colors.white.withOpacity(opacity ?? 0.1);
    }
  }

  Border _getDefaultBorder() {
    Color borderColor;
    switch (glassType) {
      case GlassType.primary:
        borderColor = const Color(0xFF3B82F6).withOpacity(0.2);
        break;
      case GlassType.secondary:
        borderColor = Colors.white.withOpacity(0.1);
        break;
      case GlassType.accent:
        borderColor = const Color(0xFF8B5CF6).withOpacity(0.2);
        break;
      case GlassType.success:
        borderColor = const Color(0xFF10B981).withOpacity(0.2);
        break;
      case GlassType.warning:
        borderColor = const Color(0xFFF59E0B).withOpacity(0.2);
        break;
      case GlassType.error:
        borderColor = const Color(0xFFEF4444).withOpacity(0.2);
        break;
      case GlassType.dark:
        borderColor = const Color(0xFF374151).withOpacity(0.3);
        break;
      case GlassType.light:
        borderColor = Colors.white.withOpacity(0.2);
        break;
    }
    return Border.all(color: borderColor, width: 1);
  }

  double _getDefaultBlur() {
    switch (glassType) {
      case GlassType.primary:
      case GlassType.accent:
        return 10.0;
      case GlassType.secondary:
      case GlassType.light:
        return 15.0;
      case GlassType.dark:
        return 8.0;
      default:
        return 12.0;
    }
  }

  List<BoxShadow> _getShadows() {
    switch (shadowType) {
      case ShadowType.none:
        return [];
      case ShadowType.soft:
        return [
          BoxShadow(
            color: (customShadowColor ?? Colors.black).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ];
      case ShadowType.medium:
        return [
          BoxShadow(
            color: (customShadowColor ?? Colors.black).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ];
      case ShadowType.hard:
        return [
          BoxShadow(
            color: (customShadowColor ?? Colors.black).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ];
      case ShadowType.glow:
        return [
          BoxShadow(color: _getGlowColor(), blurRadius: 20, spreadRadius: 2),
        ];
      case ShadowType.colored:
        return [
          BoxShadow(
            color: _getColoredShadow(),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ];
    }
  }

  Color _getGlowColor() {
    switch (glassType) {
      case GlassType.primary:
        return const Color(0xFF3B82F6).withOpacity(0.3);
      case GlassType.accent:
        return const Color(0xFF8B5CF6).withOpacity(0.3);
      case GlassType.success:
        return const Color(0xFF10B981).withOpacity(0.3);
      case GlassType.warning:
        return const Color(0xFFF59E0B).withOpacity(0.3);
      case GlassType.error:
        return const Color(0xFFEF4444).withOpacity(0.3);
      default:
        return Colors.white.withOpacity(0.2);
    }
  }

  Color _getColoredShadow() {
    switch (glassType) {
      case GlassType.primary:
        return const Color(0xFF3B82F6).withOpacity(0.2);
      case GlassType.accent:
        return const Color(0xFF8B5CF6).withOpacity(0.2);
      case GlassType.success:
        return const Color(0xFF10B981).withOpacity(0.2);
      case GlassType.warning:
        return const Color(0xFFF59E0B).withOpacity(0.2);
      case GlassType.error:
        return const Color(0xFFEF4444).withOpacity(0.2);
      default:
        return Colors.black.withOpacity(0.1);
    }
  }
}

// Predefined container variations for common use cases
class BalanceGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const BalanceGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      glassType: GlassType.primary,
      shadowType: ShadowType.glow,
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: child,
    );
  }
}

class ActionGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ActionGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      glassType: GlassType.secondary,
      shadowType: ShadowType.medium,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: child,
    );
  }
}

class StatGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? accentColor;

  const StatGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      glassType: GlassType.dark,
      shadowType: ShadowType.soft,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      borderRadius: BorderRadius.circular(12),
      border: accentColor != null
          ? Border.all(color: accentColor!.withOpacity(0.3), width: 1)
          : null,
      child: child,
    );
  }
}

class NotificationGlassContainer extends StatelessWidget {
  final Widget child;
  final bool isSuccess;
  final bool isWarning;
  final bool isError;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const NotificationGlassContainer({
    super.key,
    required this.child,
    this.isSuccess = false,
    this.isWarning = false,
    this.isError = false,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    GlassType type = GlassType.secondary;
    if (isSuccess) type = GlassType.success;
    if (isWarning) type = GlassType.warning;
    if (isError) type = GlassType.error;

    return GlassContainer(
      glassType: type,
      shadowType: ShadowType.colored,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }
}
