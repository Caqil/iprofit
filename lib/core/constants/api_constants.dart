// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl =
      'https://af6e-2001-448a-10b0-5eb1-8ad-739d-7201-f14b.ngrok-free.app/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String enableBiometric = '/user/enable-biometric';

  // Plan endpoints - FIXED: removed /user prefix
  static const String plans = '/plans';
  static const String purchasePlan = '/plans/{id}/purchase';

  // Payment endpoints
  static const String depositCoingate = '/payments/deposit/coingate';
  static const String depositUddoktapay = '/payments/deposit/uddoktapay';
  static const String depositManual = '/payments/deposit/manual';

  // Withdrawal endpoints
  static const String withdrawals = '/withdrawals';

  // Transaction endpoints
  static const String transactions = '/user/transactions';

  // Task endpoints - FIXED: removed /user prefix
  static const String tasks = '/tasks';
  static const String completeTask = '/tasks/{id}/complete';

  // Referral endpoints - FIXED: removed /user prefix
  static const String referrals = '/referrals';
  static const String referralEarnings = '/referrals/earnings';

  // KYC endpoints
  static const String kycSubmit = '/kyc/submit';
  static const String kycStatus = '/kyc/status';

  // Notification endpoints - FIXED: removed /user prefix
  static const String notifications = '/notifications';
  static const String unreadNotifications = '/notifications/unread-count';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';

  // User notifications (alternative route)
  static const String userNotifications = '/user/notifications';
  static const String markUserNotificationRead =
      '/user/notifications/{id}/read';

  // App settings (public)
  static const String appSettings = '/app-settings';
}
