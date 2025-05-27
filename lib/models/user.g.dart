// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      balance: (json['balance'] as num).toDouble(),
      referralCode: json['referral_code'] as String,
      planId: (json['plan_id'] as num).toInt(),
      isKycVerified: json['is_kyc_verified'] as bool,
      isAdmin: json['is_admin'] as bool,
      isBlocked: json['is_blocked'] as bool,
      biometricEnabled: json['biometric_enabled'] as bool,
      profilePicUrl: json['profile_pic_url'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'balance': instance.balance,
      'referral_code': instance.referralCode,
      'plan_id': instance.planId,
      'is_kyc_verified': instance.isKycVerified,
      'is_admin': instance.isAdmin,
      'is_blocked': instance.isBlocked,
      'biometric_enabled': instance.biometricEnabled,
      'profile_pic_url': instance.profilePicUrl,
      'created_at': instance.createdAt,
    };
