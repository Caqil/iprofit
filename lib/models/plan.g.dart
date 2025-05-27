// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      dailyDepositLimit: (json['daily_deposit_limit'] as num).toDouble(),
      dailyWithdrawalLimit: (json['daily_withdrawal_limit'] as num).toDouble(),
      dailyProfitLimit: (json['daily_profit_limit'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'daily_deposit_limit': instance.dailyDepositLimit,
      'daily_withdrawal_limit': instance.dailyWithdrawalLimit,
      'daily_profit_limit': instance.dailyProfitLimit,
      'price': instance.price,
      'is_default': instance.isDefault,
    };
