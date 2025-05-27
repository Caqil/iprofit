// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      gateway: $enumDecode(_$PaymentGatewayEnumMap, json['gateway']),
      gatewayReference: json['gateway_reference'] as String?,
      currency: json['currency'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'gateway': _$PaymentGatewayEnumMap[instance.gateway]!,
      'gateway_reference': instance.gatewayReference,
      'currency': instance.currency,
      'amount': instance.amount,
      'status': instance.status,
      'created_at': instance.createdAt,
    };

const _$PaymentGatewayEnumMap = {
  PaymentGateway.coingate: 'coingate',
  PaymentGateway.uddoktapay: 'uddoktapay',
  PaymentGateway.manual: 'manual',
};

Withdrawal _$WithdrawalFromJson(Map<String, dynamic> json) => Withdrawal(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      paymentDetails: json['payment_details'] as Map<String, dynamic>,
      status: json['status'] as String,
      adminNote: json['admin_note'] as String?,
      tasksCompleted: json['tasks_completed'] as bool,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$WithdrawalToJson(Withdrawal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
      'payment_details': instance.paymentDetails,
      'status': instance.status,
      'admin_note': instance.adminNote,
      'tasks_completed': instance.tasksCompleted,
      'created_at': instance.createdAt,
    };
