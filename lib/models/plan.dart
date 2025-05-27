// lib/models/plan.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'plan.g.dart';

@JsonSerializable()
class Plan extends Equatable {
  final int id;
  final String name;
  @JsonKey(name: 'daily_deposit_limit')
  final double dailyDepositLimit;
  @JsonKey(name: 'daily_withdrawal_limit')
  final double dailyWithdrawalLimit;
  @JsonKey(name: 'daily_profit_limit')
  final double dailyProfitLimit;
  final double price;
  @JsonKey(name: 'is_default')
  final bool isDefault;

  const Plan({
    required this.id,
    required this.name,
    required this.dailyDepositLimit,
    required this.dailyWithdrawalLimit,
    required this.dailyProfitLimit,
    required this.price,
    required this.isDefault,
  });

  // Manual fromJson to handle potential nulls
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      name: json['name'] as String? ?? '',
      dailyDepositLimit: json['daily_deposit_limit'] is num
          ? (json['daily_deposit_limit'] as num).toDouble()
          : 0.0,
      dailyWithdrawalLimit: json['daily_withdrawal_limit'] is num
          ? (json['daily_withdrawal_limit'] as num).toDouble()
          : 0.0,
      dailyProfitLimit: json['daily_profit_limit'] is num
          ? (json['daily_profit_limit'] as num).toDouble()
          : 0.0,
      price: json['price'] is num ? (json['price'] as num).toDouble() : 0.0,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  // We'll still use the generated toJson for convenience
  Map<String, dynamic> toJson() => _$PlanToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    dailyDepositLimit,
    dailyWithdrawalLimit,
    dailyProfitLimit,
    price,
    isDefault,
  ];
}
