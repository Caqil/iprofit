// lib/features/plans/providers/plans_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/plans_repository.dart';
import '../../../models/plan.dart';
import '../../../providers/global_providers.dart';
import '../../../features/auth/providers/auth_provider.dart';

part 'plans_provider.g.dart';

final plansRepositoryProvider = Provider<PlansRepository>((ref) {
  return PlansRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class Plans extends _$Plans {
  @override
  Future<List<Plan>> build() async {
    return ref.watch(plansRepositoryProvider).getPlans();
  }

  Future<void> purchasePlan(int planId) async {
    try {
      await ref.read(plansRepositoryProvider).purchasePlan(planId);

      // Refresh user data as balance will be updated
      ref.invalidate(authProvider);

      // Refresh plans list
      state = const AsyncLoading();
      final plans = await ref.read(plansRepositoryProvider).getPlans();
      state = AsyncValue.data(plans);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final plans = await ref.read(plansRepositoryProvider).getPlans();
      state = AsyncValue.data(plans);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
