// lib/core/services/onboarding_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';
import '../constants/onboarding_constants.dart';

// Provider for the onboarding service
final onboardingServiceProvider = Provider((ref) {
  final storageService = ref.read(storageServiceProvider);
  return OnboardingService(storageService);
});

// Provider to track onboarding state reactively
final onboardingStateProvider =
    StateNotifierProvider<OnboardingStateNotifier, OnboardingState>((ref) {
      final onboardingService = ref.read(onboardingServiceProvider);
      return OnboardingStateNotifier(onboardingService);
    });

class OnboardingService {
  final StorageService _storageService;

  OnboardingService(this._storageService);

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    await _storageService.init();
    return _storageService.getBool(
          OnboardingConstants.hasCompletedOnboarding,
        ) ??
        false;
  }

  /// Check if this is the first app launch ever
  Future<bool> isFirstLaunch() async {
    await _storageService.init();

    // Check multiple indicators to ensure this is truly the first launch
    final hasCompletedOnboarding = _storageService.getBool(
      OnboardingConstants.hasCompletedOnboarding,
    );
    final hasLaunchedBefore = _storageService.getBool('has_launched_before');
    final installTimestamp = _storageService.getInt('app_install_timestamp');

    // If any of these exist, it's not the first launch
    if (hasCompletedOnboarding != null ||
        hasLaunchedBefore != null ||
        installTimestamp != null) {
      return false;
    }

    return true;
  }

  /// Mark the app as launched (call this on every app start)
  Future<void> markAppLaunched() async {
    await _storageService.init();

    // Set install timestamp if not already set
    final installTimestamp = _storageService.getInt('app_install_timestamp');
    if (installTimestamp == null) {
      await _storageService.saveInt(
        'app_install_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    }

    // Mark that the app has been launched before
    await _storageService.saveBool('has_launched_before', true);
  }

  /// Complete the onboarding process
  Future<void> completeOnboarding() async {
    await _storageService.init();
    await _storageService.saveBool(
      OnboardingConstants.hasCompletedOnboarding,
      true,
    );

    // Also save completion timestamp for analytics
    await _storageService.saveInt(
      'onboarding_completed_timestamp',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Check if user has selected language during onboarding
  Future<bool> hasSelectedLanguage() async {
    await _storageService.init();
    return _storageService.getBool(OnboardingConstants.hasSelectedLanguage) ??
        false;
  }

  /// Save language selection
  Future<void> saveLanguageSelection(String languageCode) async {
    await _storageService.init();
    await _storageService.saveBool(
      OnboardingConstants.hasSelectedLanguage,
      true,
    );
    await _storageService.saveString('selected_language', languageCode);
  }

  /// Get saved language
  Future<String?> getSavedLanguage() async {
    await _storageService.init();
    return _storageService.getString('selected_language');
  }

  /// Reset onboarding (for testing purposes)
  Future<void> resetOnboarding() async {
    await _storageService.init();
    await _storageService.remove(OnboardingConstants.hasCompletedOnboarding);
    await _storageService.remove(OnboardingConstants.hasSelectedLanguage);
    await _storageService.remove('has_launched_before');
    await _storageService.remove('app_install_timestamp');
    await _storageService.remove('onboarding_completed_timestamp');
    await _storageService.remove('selected_language');
  }

  /// Get onboarding analytics data
  Future<Map<String, dynamic>> getOnboardingAnalytics() async {
    await _storageService.init();

    final installTimestamp = _storageService.getInt('app_install_timestamp');
    final completionTimestamp = _storageService.getInt(
      'onboarding_completed_timestamp',
    );

    return {
      'install_date': installTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(
              installTimestamp,
            ).toIso8601String()
          : null,
      'completion_date': completionTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(
              completionTimestamp,
            ).toIso8601String()
          : null,
      'time_to_complete_seconds':
          (installTimestamp != null && completionTimestamp != null)
          ? (completionTimestamp - installTimestamp) / 1000
          : null,
      'has_completed': await hasCompletedOnboarding(),
      'selected_language': await getSavedLanguage(),
    };
  }
}

// State class for onboarding
class OnboardingState {
  final bool hasCompleted;
  final bool isFirstLaunch;
  final bool isLoading;
  final String? selectedLanguage;

  const OnboardingState({
    required this.hasCompleted,
    required this.isFirstLaunch,
    this.isLoading = false,
    this.selectedLanguage,
  });

  OnboardingState copyWith({
    bool? hasCompleted,
    bool? isFirstLaunch,
    bool? isLoading,
    String? selectedLanguage,
  }) {
    return OnboardingState(
      hasCompleted: hasCompleted ?? this.hasCompleted,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isLoading: isLoading ?? this.isLoading,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

// State notifier for reactive onboarding state management
class OnboardingStateNotifier extends StateNotifier<OnboardingState> {
  final OnboardingService _onboardingService;

  OnboardingStateNotifier(this._onboardingService)
    : super(
        const OnboardingState(
          hasCompleted: false,
          isFirstLaunch: true,
          isLoading: true,
        ),
      ) {
    _initializeState();
  }

  Future<void> _initializeState() async {
    final hasCompleted = await _onboardingService.hasCompletedOnboarding();
    final isFirstLaunch = await _onboardingService.isFirstLaunch();
    final selectedLanguage = await _onboardingService.getSavedLanguage();

    // Mark app as launched
    await _onboardingService.markAppLaunched();

    state = OnboardingState(
      hasCompleted: hasCompleted,
      isFirstLaunch: isFirstLaunch,
      isLoading: false,
      selectedLanguage: selectedLanguage,
    );
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true);

    await _onboardingService.completeOnboarding();

    state = state.copyWith(
      hasCompleted: true,
      isFirstLaunch: false,
      isLoading: false,
    );
  }

  Future<void> saveLanguageSelection(String languageCode) async {
    await _onboardingService.saveLanguageSelection(languageCode);
    state = state.copyWith(selectedLanguage: languageCode);
  }

  Future<void> resetOnboarding() async {
    await _onboardingService.resetOnboarding();
    state = const OnboardingState(
      hasCompleted: false,
      isFirstLaunch: true,
      isLoading: false,
    );
  }
}
