// lib/features/onboarding/screens/onboarding_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/onboarding_constants.dart';
import '../../../core/services/onboarding_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 2; // Welcome page + Language selection page
  String? _selectedLanguageCode;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
      // Save language selection if user chose one
      if (_selectedLanguageCode != null) {
        await ref
            .read(onboardingStateProvider.notifier)
            .saveLanguageSelection(_selectedLanguageCode!);
      }

      // Complete onboarding through the service
      await ref.read(onboardingStateProvider.notifier).completeOnboarding();

      // Navigate to login screen
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing onboarding: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguageCode = languageCode;
    });

    // Change the app locale
    Locale newLocale;
    switch (languageCode) {
      case 'bn':
        newLocale = const Locale('bn', 'BD');
        break;
      case 'hi':
        newLocale = const Locale('hi', 'IN');
        break;
      case 'es':
        newLocale = const Locale('es', 'ES');
        break;
      case 'fr':
        newLocale = const Locale('fr', 'FR');
        break;
      case 'pt':
        newLocale = const Locale('pt', 'PT');
        break;
      case 'ar':
        newLocale = const Locale('ar', 'SA');
        break;
      case 'zh':
        newLocale = const Locale('zh', 'CN');
        break;
      case 'de':
        newLocale = const Locale('de', 'DE');
        break;
      case 'ru':
        newLocale = const Locale('ru', 'RU');
        break;
      case 'ja':
        newLocale = const Locale('ja', 'JP');
        break;
      default:
        newLocale = const Locale('en', 'US');
    }

    context.setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onboardingState = ref.watch(onboardingStateProvider);

    // Show loading if onboarding state is still initializing
    if (onboardingState.isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If onboarding is already completed, don't show the screen
    // (This should be handled by router, but extra safety)
    if (onboardingState.hasCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/login');
        }
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (top right)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'skip'.tr(),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [_buildWelcomePage(), _buildLanguageSelectionPage()],
              ),
            ),

            // Pagination dots (only show on welcome page)
            if (_currentPage == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalPages, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? theme.colorScheme.primary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
            ],

            // Continue/Get Started button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _currentPage == 1 && _selectedLanguageCode == null
                      ? null // Disable if on language page and no language selected
                      : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == 0 ? 'get_started'.tr() : 'continue'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo or illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(Icons.trending_up, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 40),

          // Welcome title
          Text(
            'welcome_title'.tr(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Welcome subtitle
          Text(
            'welcome_subtitle'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Feature highlights
          ..._buildFeatureHighlights(),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureHighlights() {
    final features = [
      {'icon': Icons.security, 'title': 'secure_trading'.tr()},
      {'icon': Icons.analytics, 'title': 'real_time_analytics'.tr()},
      {'icon': Icons.support_agent, 'title': '24_7_support'.tr()},
    ];

    return features.map((feature) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              feature['icon'] as IconData,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              feature['title'] as String,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildLanguageSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Choose Your Language',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select your preferred language to continue',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Language options
          Expanded(
            child: ListView.builder(
              itemCount: OnboardingConstants.supportedLanguages.length,
              itemBuilder: (context, index) {
                final language = OnboardingConstants.supportedLanguages[index];
                final isSelected = _selectedLanguageCode == language['code'];

                return GestureDetector(
                  onTap: () => _selectLanguage(language['code']!),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2)
                          : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : Border.all(color: Colors.grey.shade700, width: 1),
                    ),
                    child: Row(
                      children: [
                        Text(
                          language['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                language['nativeName']!,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                language['name']!,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
