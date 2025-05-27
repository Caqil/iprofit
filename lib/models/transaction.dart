// lib/models/transaction.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../core/enums/transaction_type.dart';
import '../core/enums/transaction_status.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends Equatable {
  final int id;
  final double amount;
  @JsonKey(name: 'type')
  final TransactionType type;
  @JsonKey(name: 'status')
  final TransactionStatus status;
  final String? description;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  List<Object?> get props => [id, amount, type, status, description, createdAt];
}
