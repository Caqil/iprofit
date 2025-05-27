// lib/models/task.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../core/enums/task_type.dart';

part 'task.g.dart';

@JsonSerializable()
class Task extends Equatable {
  final int id;
  final String name;
  final String description;
  @JsonKey(name: 'task_type')
  final TaskType taskType;
  @JsonKey(name: 'task_url')
  final String? taskUrl;
  @JsonKey(name: 'is_mandatory')
  final bool isMandatory;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;

  const Task({
    required this.id,
    required this.name,
    required this.description,
    required this.taskType,
    this.taskUrl,
    required this.isMandatory,
    required this.isCompleted,
  });

  // Manual fromJson to handle potential nulls and invalid data
  factory Task.fromJson(Map<String, dynamic> json) {
    TaskType parseTaskType(dynamic value) {
      if (value is String) {
        try {
          return TaskType.values.firstWhere(
            (e) => e.toString() == 'TaskType.$value' || e.name == value,
            orElse: () => TaskType.follow,
          );
        } catch (_) {
          return TaskType.follow;
        }
      }
      return TaskType.follow;
    }

    return Task(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      taskType: parseTaskType(json['task_type']),
      taskUrl: json['task_url'] as String?,
      isMandatory: json['is_mandatory'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  // We'll still use the generated toJson for convenience
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    taskType,
    taskUrl,
    isMandatory,
    isCompleted,
  ];
}
