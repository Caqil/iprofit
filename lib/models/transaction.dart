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

  // Manual fromJson to handle potential nulls and invalid data
  factory Transaction.fromJson(Map<String, dynamic> json) {
    TransactionType parseType(dynamic value) {
      if (value is String) {
        try {
          return TransactionType.values.firstWhere(
            (e) => e.toString() == 'TransactionType.$value' || e.name == value,
            orElse: () => TransactionType.deposit,
          );
        } catch (_) {
          return TransactionType.deposit;
        }
      }
      return TransactionType.deposit;
    }

    TransactionStatus parseStatus(dynamic value) {
      if (value is String) {
        try {
          return TransactionStatus.values.firstWhere(
            (e) =>
                e.toString() == 'TransactionStatus.$value' || e.name == value,
            orElse: () => TransactionStatus.pending,
          );
        } catch (_) {
          return TransactionStatus.pending;
        }
      }
      return TransactionStatus.pending;
    }

    return Transaction(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      amount: json['amount'] is num ? (json['amount'] as num).toDouble() : 0.0,
      type: parseType(json['type']),
      status: parseStatus(json['status']),
      description: json['description'] as String?,
      createdAt:
          json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  // We'll still use the generated toJson for convenience
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  List<Object?> get props => [id, amount, type, status, description, createdAt];
}
