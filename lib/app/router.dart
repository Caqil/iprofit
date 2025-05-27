// lib/app/router.dart - Updated with onboarding logic
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
import '../core/services/storage_service.dart' hide storageServiceProvider;
import '../providers/global_providers.dart';

final authStateChangesProvider = StreamProvider<bool>((ref) {
  // Create a controller to emit values
  final controller = StreamController<bool>();

  // Watch the auth provider and emit a value whenever it changes
  final subscription = ref.listen(authProvider, (_, state) {
    controller.add(state.valueOrNull != null);
  });

  // Close the controller when the provider is disposed
  ref.onDispose(() {
    subscription.close();
    controller.close();
  });

  // Initial value
  controller.add(ref.read(authProvider).valueOrNull != null);

  return controller.stream;
});

/// Custom RefreshStream implementation to force GoRouter to refresh on auth changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // Initial notification
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Define route names as constants for type safety
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

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = GoRouterRefreshStream(
    ref.watch(authStateChangesProvider.stream),
  );
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true, // Enable for easier debugging
    refreshListenable:
        refreshListenable, // Add this to force router refresh on auth changes
    redirect: (context, state) {
      final authStateValue = ref.read(authProvider);
      final isLoggedIn = authStateValue.valueOrNull != null;

      // Get onboarding status
      final storageService = ref.read(storageServiceProvider);
      final hasCompletedOnboarding =
          storageService.getBool(OnboardingConstants.hasCompletedOnboarding) ??
          false;

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

      // If onboarding is completed but not logged in, redirect to login
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

      return null;
    },
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
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
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailScreen(email: email);
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
      // GoRoute(
      //   path: AppRoutes.transactions,
      //   builder: (context, state) => const TransactionsScreen(),
      // ),
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
