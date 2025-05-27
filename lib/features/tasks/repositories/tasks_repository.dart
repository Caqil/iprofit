
import 'package:app/core/services/api_client.dart';

import '../../../models/task.dart';
import '../../../repositories/base_repository.dart';

class TasksRepository extends BaseRepository {
  final ApiClient _apiClient;

  TasksRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Task>> getTasks() async {
    return safeApiCall(() async {
      final response = await _apiClient.getTasks();
      final tasks = (response['tasks'] as List)
          .map((json) => Task.fromJson(json))
          .toList();
      return tasks;
    });
  }

  Future<Map<String, dynamic>> completeTask(int taskId) async {
    return safeApiCall(() async {
      final response = await _apiClient.completeTask(taskId);
      return response;
    });
  }
}
