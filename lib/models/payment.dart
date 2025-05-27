// lib/models/payment.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../core/enums/payment_gateway.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment extends Equatable {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final PaymentGateway gateway;
  @JsonKey(name: 'gateway_reference')
  final String? gatewayReference;
  final String currency;
  final double amount;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const Payment({
    required this.id,
    required this.userId,
    required this.gateway,
    this.gatewayReference,
    required this.currency,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    gateway,
    gatewayReference,
    currency,
    amount,
    status,
    createdAt,
  ];
}

@JsonSerializable()
class Withdrawal extends Equatable {
  final int id;
  final double amount;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'payment_details')
  final Map<String, dynamic> paymentDetails;
  final String status;
  @JsonKey(name: 'admin_note')
  final String? adminNote;
  @JsonKey(name: 'tasks_completed')
  final bool tasksCompleted;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const Withdrawal({
    required this.id,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDetails,
    required this.status,
    this.adminNote,
    required this.tasksCompleted,
    required this.createdAt,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawalToJson(this);

  @override
  List<Object?> get props => [
    id,
    amount,
    paymentMethod,
    paymentDetails,
    status,
    adminNote,
    tasksCompleted,
    createdAt,
  ];
}
