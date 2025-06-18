// lib/features/profile/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/profile_repository.dart';
import '../../../providers/global_providers.dart';
import '../../../models/user.dart';

part 'profile_provider.g.dart';

// Repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class Profile extends _$Profile {
  @override
  Future<User> build() async {
    final repository = ref.watch(profileRepositoryProvider);
    return repository.getProfile();
  }

  Future<void> updateProfile(
    String name,
    String phone,
    String? profilePicUrl,
  ) async {
    state = const AsyncLoading();
    try {
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

  // This method should now work since we added toggleBiometric to ProfileRepository
  Future<void> toggleBiometric(bool enable) async {
    state = const AsyncLoading();
    try {
      final updatedUser = await ref
          .read(profileRepositoryProvider)
          .toggleBiometric(enable);

      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      ref.invalidateSelf();
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await ref.read(profileRepositoryProvider).deleteAccount();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      final user = await repository.getProfile();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
