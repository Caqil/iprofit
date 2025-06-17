// lib/features/profile/providers/profile_provider.dart
import 'package:app/features/profile/repositories/profile_repository.dart' show ProfileRepository;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/user.dart';
import '../../../providers/global_providers.dart' hide biometricServiceProvider;
import '../../../core/services/biometric_service.dart';
import '../../../core/constants/storage_keys.dart';

part 'profile_provider.g.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class Profile extends _$Profile {
  @override
  Future<User> build() async {
    return ref.watch(profileRepositoryProvider).getUserProfile();
  }

  Future<void> updateProfile(
    String name,
    String phone,
    String? profilePicUrl,
  ) async {
    state = const AsyncLoading();
    try {
      // Create a map with the user data
      final userData = {
        'name': name,
        'phone': phone,
        if (profilePicUrl != null) 'profile_pic_url': profilePicUrl,
      };

      final updatedUser = await ref
          .read(profileRepositoryProvider)
          .updateProfile(userData);
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await ref
          .read(profileRepositoryProvider)
          .changePassword(currentPassword, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleBiometric() async {
    final currentUser = state.valueOrNull;
    if (currentUser == null) return;

    final biometricService = ref.read(biometricServiceProvider);
    final secureStorage = ref.read(secureStorageProvider);

    try {
      if (currentUser.biometricEnabled) {
        // Disable biometric
        await ref.read(profileRepositoryProvider).toggleBiometric(false);
        await secureStorage.delete(key: StorageKeys.biometricEnabled);

        state = AsyncValue.data(currentUser.copyWith(biometricEnabled: false));
      } else {
        // Enable biometric - Authenticate first
        final authenticated = await biometricService.authenticate(
          reason: 'Authenticate to enable biometric login',
        );

        if (authenticated) {
          await ref.read(profileRepositoryProvider).toggleBiometric(true);
          await secureStorage.write(
            key: StorageKeys.biometricEnabled,
            value: 'true',
          );

          state = AsyncValue.data(currentUser.copyWith(biometricEnabled: true));
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(profileRepositoryProvider).getProfile();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
