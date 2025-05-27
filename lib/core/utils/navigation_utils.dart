// lib/core/utils/navigation_utils.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationUtils {
  /// Navigate to a new route using GoRouter context
  static void navigateTo(BuildContext context, String route, {Object? extra}) {
    context.push(route, extra: extra);
  }

  /// Navigate to a new route and replace the current route
  static void replaceTo(BuildContext context, String route, {Object? extra}) {
    context.replace(route, extra: extra);
  }

  /// Navigate to a new route and clear the navigation stack
  static void navigateAndClear(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    context.go(route, extra: extra);
  }

  /// Go back to the previous route
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  /// Show a dialog with custom content
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required Widget content,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: content,
        );
      },
    );
  }

  /// Show a bottom sheet with custom content
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget content,
    bool isDismissible = true,
    bool enableDrag = true,
    double? heightFactor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      constraints: BoxConstraints(
        maxHeight: heightFactor != null
            ? MediaQuery.of(context).size.height * heightFactor
            : MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: content,
        );
      },
    );
  }

  /// Show a snackbar with a message
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              textStyle ??
              TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        duration: duration,
        action: action,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Navigate to a named route with query parameters
  static void navigateWithQuery(
    BuildContext context,
    String route, {
    Map<String, String>? queryParams,
    Object? extra,
  }) {
    final uri = Uri(path: route, queryParameters: queryParams);
    context.push(uri.toString(), extra: extra);
  }

  /// Get current route name
  static String? getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).name;
  }

  /// Get query parameters from current route
  static Map<String, String> getQueryParams(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }

  /// Check if a specific route is in the navigation stack
  static bool isRouteInStack(BuildContext context, String route) {
    return GoRouterState.of(context).matchedLocation.contains(route);
  }

  /// Pop until a specific route is reached
  static void popUntil(BuildContext context, String route) {
    while (context.canPop() && !isRouteInStack(context, route)) {
      context.pop();
    }
  }

  /// Show a loading dialog
  static void showLoadingDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      barrierDismissible: false,
      content: Container(
        padding: const EdgeInsets.all(16),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  /// Dismiss all dialogs
  static void dismissAllDialogs(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).popUntil((route) => route.isFirst);
  }
}
