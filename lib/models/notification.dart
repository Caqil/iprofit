// lib/models/notification.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../core/enums/notification_type.dart';

part 'notification.g.dart';

@JsonSerializable()
class AppNotification extends Equatable {
  final int id;
  final String title;
  final String message;
  @JsonKey(name: 'type')
  final NotificationType type;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  @override
  List<Object?> get props => [id, title, message, type, isRead, createdAt];

  AppNotification copyWith({
    int? id,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    String? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
