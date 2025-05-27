// lib/core/constants/onboarding_constants.dart
class OnboardingConstants {
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String hasSelectedPreferences = 'has_selected_preferences';

  // Onboarding page content
  static const List<Map<String, String>> onboardingPages = [
    {
      'title': 'Welcome to Investment App',
      'description': 'Your gateway to smart and secure investments.',
      'image': 'assets/images/onboarding/welcome.png',
    },
    {
      'title': 'Earn Money',
      'description': 'Invest in verified plans and earn daily profits.',
      'image': 'assets/images/onboarding/earn.png',
    },
    {
      'title': 'Refer & Earn',
      'description': 'Invite your friends and earn referral bonuses.',
      'image': 'assets/images/onboarding/refer.png',
    },
    {
      'title': 'Secure & Easy',
      'description': 'Fast withdrawals and 24/7 customer support.',
      'image': 'assets/images/onboarding/secure.png',
    },
  ];
}
