// lib/models/user.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final double balance;
  @JsonKey(name: 'referral_code')
  final String referralCode;
  @JsonKey(name: 'plan_id')
  final int planId;
  @JsonKey(name: 'is_kyc_verified')
  final bool isKycVerified;
  @JsonKey(name: 'is_admin')
  final bool isAdmin;
  @JsonKey(name: 'is_blocked')
  final bool isBlocked;
  @JsonKey(name: 'biometric_enabled')
  final bool biometricEnabled;
  @JsonKey(name: 'profile_pic_url')
  final String? profilePicUrl;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.balance,
    required this.referralCode,
    required this.planId,
    required this.isKycVerified,
    required this.isAdmin,
    required this.isBlocked,
    required this.biometricEnabled,
    this.profilePicUrl,
    required this.createdAt,
  });

  // Manual fromJson to handle potential nulls
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      balance: json['balance'] is num
          ? (json['balance'] as num).toDouble()
          : 0.0,
      referralCode: json['referral_code'] as String? ?? '',
      planId: json['plan_id'] is num ? (json['plan_id'] as num).toInt() : 0,
      isKycVerified: json['is_kyc_verified'] as bool? ?? false,
      isAdmin: json['is_admin'] as bool? ?? false,
      isBlocked: json['is_blocked'] as bool? ?? false,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      profilePicUrl: json['profile_pic_url'] as String?,
      createdAt:
          json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  // We'll still use the generated toJson for convenience
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    balance,
    referralCode,
    planId,
    isKycVerified,
    isAdmin,
    isBlocked,
    biometricEnabled,
    profilePicUrl,
    createdAt,
  ];

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    double? balance,
    String? referralCode,
    int? planId,
    bool? isKycVerified,
    bool? isAdmin,
    bool? isBlocked,
    bool? biometricEnabled,
    String? profilePicUrl,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      referralCode: referralCode ?? this.referralCode,
      planId: planId ?? this.planId,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      isAdmin: isAdmin ?? this.isAdmin,
      isBlocked: isBlocked ?? this.isBlocked,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
