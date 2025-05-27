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

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
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
