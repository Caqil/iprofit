// lib/models/withdrawal.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'withdrawal.g.dart';

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

  // Helper method to get formatted payment details
  List<Map<String, String>> getFormattedPaymentDetails() {
    final List<Map<String, String>> result = [];

    paymentDetails.forEach((key, value) {
      // Convert snake_case to Title Case
      final formattedKey = key
          .split('_')
          .map(
            (word) => word.isEmpty
                ? ''
                : '${word[0].toUpperCase()}${word.substring(1)}',
          )
          .join(' ');

      result.add({'key': formattedKey, 'value': value.toString()});
    });

    return result;
  }

  // Helper method to check status
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';
}
