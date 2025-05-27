
import 'package:app/core/services/api_client.dart';

import '../../../models/notification.dart';
import '../../../repositories/base_repository.dart';

class NotificationsRepository extends BaseRepository {
  final ApiClient _apiClient;

  NotificationsRepository({required ApiClient apiClient})
    : _apiClient = apiClient;

  Future<List<AppNotification>> getNotifications() async {
    return safeApiCall(() async {
      final response = await _apiClient.getNotifications();

      final notifications = (response['notifications'] as List)
          .map((json) => AppNotification.fromJson(json))
          .toList();

      return notifications;
    });
  }

  Future<int> getUnreadNotificationsCount() async {
    return safeApiCall(() async {
      final response = await _apiClient.getUnreadNotificationsCount();
      return response['unread_count'] as int;
    });
  }

  Future<void> markNotificationAsRead(int id) async {
    return safeApiCall(() async {
      await _apiClient.markNotificationAsRead(id);
    });
  }

  Future<void> markAllNotificationsAsRead() async {
    return safeApiCall(() async {
      await _apiClient.markAllNotificationsAsRead();
    });
  }
}
