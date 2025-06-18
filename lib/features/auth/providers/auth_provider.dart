// lib/features/auth/providers/auth_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';
import '../../profile/repositories/profile_repository.dart';
import '../../../models/user.dart';
import '../../../providers/global_providers.dart';
import '../../../core/services/device_service.dart' as deviceServiceProvider;

part 'auth_provider.g.dart';

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

// User repository provider for profile management
final userRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(apiClient: ref.watch(apiClientProvider));
});

// Auth state provider
@riverpod
class Auth extends _$Auth {
  @override
  Future<User?> build() async {
    return _initializeAuthState();
  }

  // Initialize auth state by checking if user is logged in
  Future<User?> _initializeAuthState() async {
    final repository = ref.watch(authRepositoryProvider);
    final isLoggedIn = await repository.isLoggedIn();

    if (!isLoggedIn) {
      return null;
    }

    try {
      // Fetch user profile
      final user = await ref.read(userRepositoryProvider).getProfile();
      return user;
    } catch (e) {
      // If error fetching profile, logout and return null
      await repository.logout();
      return null;
    }
  }

  // Login user
  Future<User> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      final deviceId = await ref
          .read(deviceServiceProvider.deviceServiceProvider)
          .getDeviceId();
      final user = await ref
          .read(authRepositoryProvider)
          .login(email, password, deviceId);

      state = AsyncData(user);
      return user;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  // Register user
  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String? referCode,
  ) async {
    state = const AsyncLoading();

    try {
      final deviceId = await ref
          .read(deviceServiceProvider.deviceServiceProvider)
          .getDeviceId();
      await ref
          .read(authRepositoryProvider)
          .register(name, email, password, phone, deviceId, referCode);

      // Reset state after registration (user will need to login)
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  // Verify email
  Future<void> verifyEmail(String email, String code) async {
    try {
      await ref.read(authRepositoryProvider).verifyEmail(email, code);
    } catch (e) {
      rethrow;
    }
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await ref.read(authRepositoryProvider).forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(
    String email,
    String token,
    String newPassword,
  ) async {
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(email, token, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  // Logout user
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (state.valueOrNull == null) return;

    state = const AsyncLoading();
    try {
      final user = await ref.read(userRepositoryProvider).getProfile();
      state = AsyncData(user);
    } catch (e) {
      await logout();
    }
  }
}

// Stream provider for auth state changes
final authStateProvider = StreamProvider<bool>((ref) {
  final controller = StreamController<bool>();

  // Watch auth provider changes
  final subscription = ref.listen(authProvider, (previous, next) {
    // Emit true if user is logged in, false otherwise
    controller.add(next.valueOrNull != null);
  });

  // Initial value
  controller.add(ref.read(authProvider).valueOrNull != null);

  // Cleanup
  ref.onDispose(() {
    subscription.close();
    controller.close();
  });

  return controller.stream;
});
