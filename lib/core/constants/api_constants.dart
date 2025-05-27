// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'http://your-go-api-url.com/api';

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

  // Plan endpoints
  static const String plans = '/plans';
  static const String purchasePlan = '/plans/{id}/purchase';

  // Wallet endpoints
  static const String deposits = '/payments/deposit';
  static const String depositCoingate = '/payments/deposit/coingate';
  static const String depositUddoktapay = '/payments/deposit/uddoktapay';
  static const String depositManual = '/payments/deposit/manual';
  static const String withdrawals = '/withdrawals';
  static const String transactions = '/user/transactions';

  // Task endpoints
  static const String tasks = '/tasks';
  static const String completeTask = '/tasks/{id}/complete';

  // Referral endpoints
  static const String referrals = '/referrals';
  static const String referralEarnings = '/referrals/earnings';

  // KYC endpoints
  static const String kycSubmit = '/kyc/submit';
  static const String kycStatus = '/kyc/status';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String unreadNotifications = '/notifications/unread-count';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';
}
