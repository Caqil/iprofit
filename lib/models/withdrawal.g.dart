// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
