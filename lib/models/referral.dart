// lib/models/referral.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'referral.g.dart';

@JsonSerializable()
class Referral extends Equatable {
  final int id;
  final String name;
  final String email;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const Referral({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isActive,
  });

  factory Referral.fromJson(Map<String, dynamic> json) =>
      _$ReferralFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralToJson(this);

  @override
  List<Object?> get props => [id, name, email, createdAt, isActive];
}
