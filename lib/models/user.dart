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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
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
