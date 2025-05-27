
import 'package:app/core/services/api_service.dart';

import '../../../core/enums/document_type.dart';
import '../../../repositories/base_repository.dart';

class KycRepository extends BaseRepository {
  final ApiClient _apiClient;

  KycRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Map<String, dynamic>> submitKyc(
    DocumentType documentType,
    String documentFrontUrl,
    String? documentBackUrl,
    String selfieUrl,
  ) async {
    return safeApiCall(() async {
      final response = await _apiClient.submitKyc({
        'document_type': documentType.name,
        'document_front_url': documentFrontUrl,
        'document_back_url': documentBackUrl,
        'selfie_url': selfieUrl,
      });
      return response;
    });
  }

  Future<Map<String, dynamic>> getKycStatus() async {
    return safeApiCall(() async {
      final response = await _apiClient.getKycStatus();
      return response;
    });
  }
}
