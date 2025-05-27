// lib/features/kyc/models/kyc_submission.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../core/enums/document_type.dart';

part 'kyc_submission.g.dart';

@JsonSerializable()
class KycSubmission {
  @JsonKey(name: 'document_type')
  final DocumentType documentType;
  @JsonKey(name: 'document_front_url')
  final String documentFrontUrl;
  @JsonKey(name: 'document_back_url')
  final String? documentBackUrl;
  @JsonKey(name: 'selfie_url')
  final String selfieUrl;

  KycSubmission({
    required this.documentType,
    required this.documentFrontUrl,
    this.documentBackUrl,
    required this.selfieUrl,
  });

  factory KycSubmission.fromJson(Map<String, dynamic> json) =>
      _$KycSubmissionFromJson(json);
  Map<String, dynamic> toJson() => _$KycSubmissionToJson(this);
}

@JsonSerializable()
class KycResponse {
  final String message;
  final Map<String, dynamic> kyc;

  KycResponse({required this.message, required this.kyc});

  factory KycResponse.fromJson(Map<String, dynamic> json) =>
      _$KycResponseFromJson(json);
  Map<String, dynamic> toJson() => _$KycResponseToJson(this);
}

@JsonSerializable()
class KycStatus {
  final int id;
  @JsonKey(name: 'document_type')
  final DocumentType documentType;
  final String status;
  @JsonKey(name: 'admin_note')
  final String? adminNote;
  @JsonKey(name: 'created_at')
  final String createdAt;

  KycStatus({
    required this.id,
    required this.documentType,
    required this.status,
    this.adminNote,
    required this.createdAt,
  });

  factory KycStatus.fromJson(Map<String, dynamic> json) =>
      _$KycStatusFromJson(json);
  Map<String, dynamic> toJson() => _$KycStatusToJson(this);
}
