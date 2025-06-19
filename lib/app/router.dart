// lib/app/router.dart (Simplified version)
import 'package:app/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../core/services/onboarding_service.dart';

// Define route names as constants
class AppRoutes {
  static const String splash = '/splash';
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

// Simple Router Notifier - minimal redirects
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    // Listen to auth state changes for navigation updates
    _ref.listen<AsyncValue<dynamic>>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;

  // Get current auth state - only check if user is loaded, not loading state
  bool get isLoggedIn {
    final authState = _ref.read(authProvider);
    return authState.valueOrNull != null;
  }

  // Get onboarding state
  OnboardingState get onboardingState {
    return _ref.read(onboardingStateProvider);
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final currentPath = state.uri.path;
    final onboardingState = this.onboardingState;

    // NEVER redirect from splash screen - let it handle navigation
    if (currentPath == AppRoutes.splash) {
      return null;
    }

    // Don't redirect if onboarding is still loading
    if (onboardingState.isLoading) {
      return null;
    }

    // Public routes that don't need auth or onboarding
    final publicRoutes = [
      AppRoutes.splash,
      AppRoutes.onboarding,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.verifyEmail,
      AppRoutes.forgotPassword,
    ];

    // If user hasn't completed onboarding, redirect to onboarding
    if (!onboardingState.hasCompleted && !publicRoutes.contains(currentPath)) {
      return AppRoutes.onboarding;
    }

    // If user is trying to access onboarding but has already completed it
    if (currentPath == AppRoutes.onboarding && onboardingState.hasCompleted) {
      // Don't redirect based on auth here - let splash handle this logic
      return AppRoutes.splash;
    }

    // For protected routes, check if user is logged in
    // But be less aggressive about redirects - let screens handle their own auth checks
    final authState = _ref.read(authProvider);
    final isLoggedIn = authState.valueOrNull != null;

    // Only redirect to login if:
    // 1. User is trying to access protected route
    // 2. Auth state is definitely resolved (not loading)
    // 3. User is definitely not logged in
    if (!publicRoutes.contains(currentPath) &&
        authState is! AsyncLoading &&
        !isLoggedIn &&
        onboardingState.hasCompleted) {
      return AppRoutes.login;
    }

    // If user is on auth route but already logged in, go to home
    if (isLoggedIn &&
        [AppRoutes.login, AppRoutes.register].contains(currentPath)) {
      return AppRoutes.home;
    }

    // No redirect needed
    return null;
  }
}

// Router configuration with splash screen as initial route
final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash, // Always start with splash
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      // Splash Screen (Initial Route)
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Route
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
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

      // Main App Routes
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
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const Scaffold(body: Center(child: Text('Invalid news ID')));
          }
          return NewsDetailScreen(newsId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});
