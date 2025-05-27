// lib/app/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/verify_email_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/home/screens/main_screen.dart';
import '../features/plans/screens/plans_screen.dart';
import '../features/wallet/screens/wallet_screen.dart';
import '../features/wallet/screens/deposit_screen.dart';
import '../features/wallet/screens/withdrawal_screen.dart';
import '../features/wallet/screens/transactions_screen.dart';
import '../features/tasks/screens/tasks_screen.dart';
import '../features/referrals/screens/referrals_screen.dart';
import '../features/kyc/screens/kyc_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/change_password_screen.dart';
import '../features/news/screens/news_screen.dart';
import '../features/news/screens/news_detail_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../core/constants/onboarding_constants.dart';
import '../core/services/storage_service.dart';
import '../providers/global_providers.dart' as storageServiceProvider;

// Define route names as constants
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/';
  static const String plans = '/plans';
  static const String wallet = '/wallet';
  static const String deposit = '/deposit';
  static const String withdrawal = '/withdrawal';
  static const String transactions = '/transactions';
  static const String tasks = '/tasks';
  static const String referrals = '/referrals';
  static const String kyc = '/kyc';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String news = '/news';
  static const String newsDetail = '/news/:id';
  static const String notifications = '/notifications';
}

// Router Notifier to handle auth state changes safely
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<bool>>(
      _authStateListenable,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;

  // Simple boolean state provider to avoid dependency issues
  final _authStateListenable = StateProvider<AsyncValue<bool>>((ref) {
    return ref.watch(authProvider).whenData((user) => user != null);
  });

  // Safe way to get auth state
  bool get isLoggedIn {
    final authState = _ref.read(_authStateListenable);
    return authState.valueOrNull ?? false;
  }

  // Safe way to get onboarding state
  bool get hasCompletedOnboarding {
    final storageService = _ref.read(
      storageServiceProvider.storageServiceProvider,
    );
    return storageService.getBool(OnboardingConstants.hasCompletedOnboarding) ??
        false;
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = this.isLoggedIn;
    final hasCompletedOnboarding = this.hasCompletedOnboarding;

    // Define auth routes
    final isAuthRoute = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.verifyEmail,
      AppRoutes.forgotPassword,
    ].contains(state.uri.path);

    final isOnboardingRoute = state.uri.path == AppRoutes.onboarding;

    // If onboarding is not completed, redirect to onboarding
    if (!hasCompletedOnboarding && !isOnboardingRoute) {
      return AppRoutes.onboarding;
    }

    // If onboarding is completed but not logged in, redirect to login for protected routes
    if (hasCompletedOnboarding && !isLoggedIn && !isAuthRoute) {
      return AppRoutes.login;
    }

    // If logged in but on auth route, redirect to home
    if (isLoggedIn && isAuthRoute) {
      return AppRoutes.home;
    }

    // If onboarding is completed and trying to access onboarding, redirect to appropriate page
    if (hasCompletedOnboarding && isOnboardingRoute) {
      return isLoggedIn ? AppRoutes.home : AppRoutes.login;
    }

    // No redirection needed
    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
    routes: [
      // Onboarding route
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) {
          final email = state.extra is Map
              ? (state.extra as Map)['email'] as String?
              : null;
          return VerifyEmailScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main app routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.plans,
        builder: (context, state) => const PlansScreen(),
      ),
      GoRoute(
        path: AppRoutes.wallet,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: AppRoutes.deposit,
        builder: (context, state) => const DepositScreen(),
      ),
      GoRoute(
        path: AppRoutes.withdrawal,
        builder: (context, state) => const WithdrawalScreen(),
      ),
      GoRoute(
        path: AppRoutes.transactions,
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tasks,
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: AppRoutes.referrals,
        builder: (context, state) => const ReferralsScreen(),
      ),
      GoRoute(
        path: AppRoutes.kyc,
        builder: (context, state) => const KycScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.news,
        builder: (context, state) => const NewsScreen(),
      ),
      GoRoute(
        path: AppRoutes.newsDetail,
        builder: (context, state) {
          final newsId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return NewsDetailScreen(newsId: newsId);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});
