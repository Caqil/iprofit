// lib/features/wallet/models/deposit_request.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../core/enums/payment_gateway.dart';

part 'deposit_request.g.dart';

@JsonSerializable()
class DepositRequest {
  final double amount;

  DepositRequest({required this.amount});

  factory DepositRequest.fromJson(Map<String, dynamic> json) =>
      _$DepositRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DepositRequestToJson(this);
}

@JsonSerializable()
class ManualDepositRequest {
  final double amount;
  @JsonKey(name: 'transaction_id')
  final String transactionId;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'sender_information')
  final Map<String, dynamic> senderInformation;

  ManualDepositRequest({
    required this.amount,
    required this.transactionId,
    required this.paymentMethod,
    required this.senderInformation,
  });

  factory ManualDepositRequest.fromJson(Map<String, dynamic> json) =>
      _$ManualDepositRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ManualDepositRequestToJson(this);
}

@JsonSerializable()
class DepositResponse {
  final String message;
  @JsonKey(name: 'payment_url')
  final String? paymentUrl;
  final Map<String, dynamic>? payment;

  DepositResponse({required this.message, this.paymentUrl, this.payment});

  factory DepositResponse.fromJson(Map<String, dynamic> json) =>
      _$DepositResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DepositResponseToJson(this);
}
