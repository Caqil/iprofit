// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      taskType: $enumDecode(_$TaskTypeEnumMap, json['task_type']),
      taskUrl: json['task_url'] as String?,
      isMandatory: json['is_mandatory'] as bool,
      isCompleted: json['is_completed'] as bool,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'task_type': _$TaskTypeEnumMap[instance.taskType]!,
      'task_url': instance.taskUrl,
      'is_mandatory': instance.isMandatory,
      'is_completed': instance.isCompleted,
    };

const _$TaskTypeEnumMap = {
  TaskType.follow: 'follow',
  TaskType.like: 'like',
  TaskType.install: 'install',
};
