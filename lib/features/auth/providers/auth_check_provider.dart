// lib/features/splash/providers/auth_check_provider.dart
import 'package:app/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/repositories/auth_repository.dart';

/// Simple auth check provider that only checks if token exists
/// Does NOT fetch user profile or make API calls
/// Used in splash screen for fast authentication check
final authCheckProvider = FutureProvider<bool>((ref) async {
  try {
    final authRepository = ref.read(authRepositoryProvider);

    // This only checks local storage - no API calls
    final isLoggedIn = await authRepository.isLoggedIn();

    print('Auth check result: $isLoggedIn');
    return isLoggedIn;
  } catch (e) {
    print('Auth check error: $e');
    // If error checking token, assume not logged in
    return false;
  }
});
