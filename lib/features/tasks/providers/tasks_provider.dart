// lib/features/tasks/providers/tasks_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/tasks_repository.dart';
import '../../../models/task.dart';
import '../../../providers/global_providers.dart';

part 'tasks_provider.g.dart';

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  return TasksRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class Tasks extends _$Tasks {
  @override
  Future<List<Task>> build() async {
    return ref.watch(tasksRepositoryProvider).getTasks();
  }

  Future<Map<String, dynamic>> completeTask(int taskId) async {
    final currentTasks = state.valueOrNull ?? [];

    try {
      final response = await ref
          .read(tasksRepositoryProvider)
          .completeTask(taskId);

      // Update the local task list
      state = AsyncValue.data(
        currentTasks.map((task) {
          if (task.id == taskId) {
            return Task(
              id: task.id,
              name: task.name,
              description: task.description,
              taskType: task.taskType,
              taskUrl: task.taskUrl,
              isMandatory: task.isMandatory,
              isCompleted: true,
            );
          }
          return task;
        }).toList(),
      );

      return response;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final tasks = await ref.read(tasksRepositoryProvider).getTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
