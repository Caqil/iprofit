// lib/features/kyc/providers/kyc_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/kyc_repository.dart';
import '../../../core/enums/document_type.dart';
import '../../../providers/global_providers.dart';

part 'kyc_provider.g.dart';

final kycRepositoryProvider = Provider<KycRepository>((ref) {
  return KycRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class Kyc extends _$Kyc {
  @override
  Future<Map<String, dynamic>> build() async {
    return ref.watch(kycRepositoryProvider).getKycStatus();
  }

  Future<void> submitKyc(
    DocumentType documentType,
    String documentFrontUrl,
    String? documentBackUrl,
    String selfieUrl,
  ) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(kycRepositoryProvider)
          .submitKyc(
            documentType,
            documentFrontUrl,
            documentBackUrl,
            selfieUrl,
          );
      state = AsyncValue.data(
        await ref.read(kycRepositoryProvider).getKycStatus(),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final kycStatus = await ref.read(kycRepositoryProvider).getKycStatus();
      state = AsyncValue.data(kycStatus);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
