// lib/features/onboarding/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/onboarding_constants.dart';
import '../../../providers/global_providers.dart' as storageServiceProvider;

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
    final storageService = ref.read(
      storageServiceProvider.storageServiceProvider,
    );

    // Mark onboarding as completed
    await storageService.saveBool(
      OnboardingConstants.hasCompletedOnboarding,
      true,
    );

    // Mark language as selected if user chose one
    if (_selectedLanguageCode != null) {
      await storageService.saveBool(
        OnboardingConstants.hasSelectedLanguage,
        true,
      );
    }

    // Navigate to login screen
    if (mounted) {
      context.go('/login');
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
    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Dark background like image
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
                          ? const Color(0xFF1E90FF)
                          : Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
            ],

            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _currentPage == 1 && _selectedLanguageCode == null
                      ? null
                      : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E90FF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'next'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Investment icon with plant growing (matching image style)
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [Color(0xFF2D5BA8), Color(0xFF1A4A8A)],
                center: Alignment.center,
              ),
              borderRadius: BorderRadius.circular(90),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Plant/money growing icon
                Icon(Icons.eco, size: 60, color: Colors.green.shade300),
                const Positioned(
                  top: 30,
                  child: Icon(
                    Icons.attach_money,
                    size: 24,
                    color: Colors.yellow,
                  ),
                ),
                const Positioned(
                  bottom: 40,
                  child: Icon(Icons.trending_up, size: 32, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            'grow_your_wealth'.tr(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'investment_pro_gives_access'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Features (matching image exactly)
          _buildFeatureItem(
            icon: Icons.schedule,
            title: 'daily_profits'.tr(),
            subtitle: 'earn_returns_every_24_hours'.tr(),
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            icon: Icons.verified_user,
            title: 'secure_platform'.tr(),
            subtitle: 'your_investments_are_protected'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E90FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1E90FF), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Language selection icon (matching image)
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1E90FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.language, size: 40, color: Colors.white),
                Positioned(
                  top: 25,
                  left: 25,
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: Colors.white70,
                  ),
                ),
                Positioned(
                  bottom: 25,
                  right: 25,
                  child: Icon(Icons.translate, size: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Title with icon (matching image)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language, color: Color(0xFF1E90FF), size: 24),
              const SizedBox(width: 8),
              Text(
                'select_language'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Language grid (exactly matching image layout)
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: OnboardingConstants.supportedLanguages.length,
              itemBuilder: (context, index) {
                final language = OnboardingConstants.supportedLanguages[index];
                final isSelected = _selectedLanguageCode == language['code'];

                return InkWell(
                  onTap: () => _selectLanguage(language['code']!),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E90FF)
                          : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF1E90FF), width: 2)
                          : Border.all(color: Colors.grey.shade700, width: 1),
                    ),
                    child: Row(
                      children: [
                        Text(
                          language['flag']!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            language['nativeName']!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 18,
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
