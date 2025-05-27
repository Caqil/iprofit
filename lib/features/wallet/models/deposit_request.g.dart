// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositRequest _$DepositRequestFromJson(Map<String, dynamic> json) =>
    DepositRequest(
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$DepositRequestToJson(DepositRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
    };

ManualDepositRequest _$ManualDepositRequestFromJson(
        Map<String, dynamic> json) =>
    ManualDepositRequest(
      amount: (json['amount'] as num).toDouble(),
      transactionId: json['transaction_id'] as String,
      paymentMethod: json['payment_method'] as String,
      senderInformation: json['sender_information'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ManualDepositRequestToJson(
        ManualDepositRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'transaction_id': instance.transactionId,
      'payment_method': instance.paymentMethod,
      'sender_information': instance.senderInformation,
    };

DepositResponse _$DepositResponseFromJson(Map<String, dynamic> json) =>
    DepositResponse(
      message: json['message'] as String,
      paymentUrl: json['payment_url'] as String?,
      payment: json['payment'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DepositResponseToJson(DepositResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'payment_url': instance.paymentUrl,
      'payment': instance.payment,
    };
