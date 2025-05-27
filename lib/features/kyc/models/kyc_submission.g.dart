// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KycSubmission _$KycSubmissionFromJson(Map<String, dynamic> json) =>
    KycSubmission(
      documentType: $enumDecode(_$DocumentTypeEnumMap, json['document_type']),
      documentFrontUrl: json['document_front_url'] as String,
      documentBackUrl: json['document_back_url'] as String?,
      selfieUrl: json['selfie_url'] as String,
    );

Map<String, dynamic> _$KycSubmissionToJson(KycSubmission instance) =>
    <String, dynamic>{
      'document_type': _$DocumentTypeEnumMap[instance.documentType]!,
      'document_front_url': instance.documentFrontUrl,
      'document_back_url': instance.documentBackUrl,
      'selfie_url': instance.selfieUrl,
    };

const _$DocumentTypeEnumMap = {
  DocumentType.idCard: 'idCard',
  DocumentType.passport: 'passport',
  DocumentType.drivingLicense: 'drivingLicense',
};

KycResponse _$KycResponseFromJson(Map<String, dynamic> json) => KycResponse(
      message: json['message'] as String,
      kyc: json['kyc'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$KycResponseToJson(KycResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'kyc': instance.kyc,
    };

KycStatus _$KycStatusFromJson(Map<String, dynamic> json) => KycStatus(
      id: (json['id'] as num).toInt(),
      documentType: $enumDecode(_$DocumentTypeEnumMap, json['document_type']),
      status: json['status'] as String,
      adminNote: json['admin_note'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$KycStatusToJson(KycStatus instance) => <String, dynamic>{
      'id': instance.id,
      'document_type': _$DocumentTypeEnumMap[instance.documentType]!,
      'status': instance.status,
      'admin_note': instance.adminNote,
      'created_at': instance.createdAt,
    };
