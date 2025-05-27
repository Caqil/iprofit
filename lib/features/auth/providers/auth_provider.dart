
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../profile/repositories/user_repository.dart';
import '../repositories/auth_repository.dart';
import '../../../models/user.dart';
import '../../../providers/global_providers.dart' hide deviceServiceProvider;
import '../../../core/services/device_service.dart';

part 'auth_provider.g.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  ),
);

@riverpod
class Auth extends _$Auth {
  @override
  Future<User?> build() async {
    // Check if user is logged in on app start
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
      // If error fetching profile, logout
      await repository.logout();
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      final deviceId = await ref.read(deviceServiceProvider).getDeviceId();
      final user = await ref
          .read(authRepositoryProvider)
          .login(email, password, deviceId);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String? referCode,
  ) async {
    try {
      state = const AsyncLoading();
      final deviceId = await ref.read(deviceServiceProvider).getDeviceId();
      await ref
          .read(authRepositoryProvider)
          .register(name, email, password, phone, deviceId, referCode);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

// User repository provider for profile
final userRepositoryProvider = Provider(
  (ref) => UserRepository(apiClient: ref.watch(apiClientProvider)),
);
