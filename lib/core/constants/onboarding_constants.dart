// lib/core/constants/onboarding_constants.dart
class OnboardingConstants {
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String hasSelectedLanguage = 'has_selected_language';

  // Language data for onboarding language selection (matching image)
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা', 'flag': '🇧🇩'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी', 'flag': '🇮🇳'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français', 'flag': '🇫🇷'},
    {
      'code': 'pt',
      'name': 'Portuguese',
      'nativeName': 'Português',
      'flag': '🇵🇹',
    },
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية', 'flag': '🇸🇦'},
    {'code': 'zh', 'name': 'Chinese', 'nativeName': '中文', 'flag': '🇨🇳'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский', 'flag': '🇷🇺'},
    {'code': 'ja', 'name': 'Japanese', 'nativeName': '日本語', 'flag': '🇯🇵'},
  ];
}
