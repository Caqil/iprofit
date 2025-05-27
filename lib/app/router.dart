// lib/app/router.dart
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

// Define route names as constants for type safety
class AppRoutes {
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
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true, // Enable for easier debugging
    redirect: (context, state) async {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.verifyEmail,
        AppRoutes.forgotPassword,
      ].contains(state.uri.path);

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
    routes: [
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
