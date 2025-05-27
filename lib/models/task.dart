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

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
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
