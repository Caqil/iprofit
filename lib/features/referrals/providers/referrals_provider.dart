// lib/features/referrals/providers/referrals_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/referrals_repository.dart';
import '../../../models/referral.dart';
import '../../../providers/global_providers.dart';
import 'package:share_plus/share_plus.dart';

part 'referrals_provider.g.dart';

final referralsRepositoryProvider = Provider<ReferralsRepository>((ref) {
  return ReferralsRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class ReferralInfo extends _$ReferralInfo {
  @override
  Future<Map<String, dynamic>> build() async {
    final referrals = await ref
        .watch(referralsRepositoryProvider)
        .getReferrals();
    final earnings = await ref
        .watch(referralsRepositoryProvider)
        .getReferralEarnings();

    return {
      'referrals': (referrals['referrals'] as List)
          .map((json) => Referral.fromJson(json))
          .toList(),
      'total_referrals': _safeIntCast(referrals['total_referrals']),
      'total_earnings': _safeDoubleCast(earnings['total_earnings']),
      'referral_code': earnings['referral_code'] as String,
    };
  }

  Future<void> shareReferralCode(String referralCode) async {
    await Share.share(
      'Join Investment App using my referral code: $referralCode and get a bonus! Download the app now: https://investmentapp.com/download',
      subject: 'Join Investment App with my referral code',
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final referrals = await ref
          .read(referralsRepositoryProvider)
          .getReferrals();
      final earnings = await ref
          .read(referralsRepositoryProvider)
          .getReferralEarnings();

      state = AsyncValue.data({
        'referrals': (referrals['referrals'] as List)
            .map((json) => Referral.fromJson(json))
            .toList(),
        'total_referrals': _safeIntCast(referrals['total_referrals']),
        'total_earnings': _safeDoubleCast(earnings['total_earnings']),
        'referral_code': earnings['referral_code'] as String,
      });
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Helper method to safely cast numeric values to int
  int _safeIntCast(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Helper method to safely cast numeric values to double
  double _safeDoubleCast(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
