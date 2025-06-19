// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/onboarding_service.dart';
import '../auth/providers/auth_check_provider.dart';
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  String _loadingText = 'Welcome...';

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start animations
    _logoController.forward();
    _fadeController.forward();

    // Simple initialization - no data preloading needed!
    _initializeApp();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Show splash for minimum time
      final minimumTime = Future.delayed(const Duration(seconds: 2));

      // Simple checks only - no data loading!
      await _performSimpleChecks();

      // Wait for minimum time
      await minimumTime;

      // Navigate
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      print('Splash initialization error: $e');
      if (mounted) {
        // On error, go to login
        context.go('/login');
      }
    }
  }

  Future<void> _performSimpleChecks() async {
    // Step 1: Check onboarding
    setState(() => _loadingText = 'Checking setup...');
    await _waitForOnboarding();

    final onboardingState = ref.read(onboardingStateProvider);
    if (!onboardingState.hasCompleted) {
      setState(() => _loadingText = 'First time setup...');
      return;
    }

    // Step 2: Simple auth check (token only)
    setState(() => _loadingText = 'Checking authentication...');
    await _checkAuthToken();

    setState(() => _loadingText = 'Ready!');
  }

  Future<void> _waitForOnboarding() async {
    int attempts = 0;
    while (ref.read(onboardingStateProvider).isLoading && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
  }

  Future<void> _checkAuthToken() async {
    // Just trigger the auth check - no data preloading
    ref.read(authCheckProvider);

    // Give it a moment to check
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _navigateToNextScreen() {
    final onboardingState = ref.read(onboardingStateProvider);

    // Check onboarding first
    if (!onboardingState.hasCompleted) {
      print('🔄 Navigating to onboarding - first time user');
      context.go('/onboarding');
      return;
    }

    // Check auth status
    final authCheck = ref.read(authCheckProvider);

    authCheck.when(
      data: (isLoggedIn) {
        if (isLoggedIn) {
          print('🏠 Navigating to home - data will load from cache instantly');
          context.go('/');
        } else {
          print('🔐 Navigating to login - no valid token');
          context.go('/login');
        }
      },
      loading: () {
        print('⏳ Auth check still loading - defaulting to login');
        context.go('/login');
      },
      error: (error, stack) {
        print('❌ Auth check error: $error - going to login');
        context.go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A1A),
              theme.colorScheme.primary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.trending_up,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // App Name
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Column(
                              children: [
                                Text(
                                  'Investment Pro',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Smart Investment Platform',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.7),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Simple loading indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: Column(
                  children: [
                    // Loading indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Loading text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _loadingText,
                        key: ValueKey(_loadingText),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
