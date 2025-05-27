// lib/features/notifications/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/notification.dart';
import '../../../core/services/api_client.dart';
import '../../../providers/global_providers.dart';

part 'notifications_provider.g.dart';

@riverpod
class Notifications extends _$Notifications {
  @override
  Future<List<AppNotification>> build() async {
    final apiClient = ref.watch(apiClientProvider);

    try {
      final response = await apiClient.getNotifications(limit: 50);
      final List<dynamic> notificationData = response['notifications'] ?? [];

      return notificationData
          .map((json) => AppNotification.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading notifications: $e');
      try {
        // Fallback to user notifications endpoint
        final response = await apiClient.getUserNotifications(limit: 50);
        final List<dynamic> notificationData = response['notifications'] ?? [];

        return notificationData
            .map((json) => AppNotification.fromJson(json))
            .toList();
      } catch (e2) {
        print('Error loading user notifications: $e2');
        return [];
      }
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final apiClient = ref.read(apiClientProvider);

      try {
        final response = await apiClient.getNotifications(limit: 50);
        final List<dynamic> notificationData = response['notifications'] ?? [];

        final notifications = notificationData
            .map((json) => AppNotification.fromJson(json))
            .toList();

        state = AsyncValue.data(notifications);
      } catch (e) {
        // Fallback to user notifications endpoint
        final response = await apiClient.getUserNotifications(limit: 50);
        final List<dynamic> notificationData = response['notifications'] ?? [];

        final notifications = notificationData
            .map((json) => AppNotification.fromJson(json))
            .toList();

        state = AsyncValue.data(notifications);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      try {
        await apiClient.markNotificationAsRead(notificationId);
      } catch (e) {
        // Fallback to user notification endpoint
        await apiClient.markUserNotificationAsRead(notificationId);
      }

      // Update the local state
      final currentNotifications = state.valueOrNull ?? [];
      final updatedNotifications = currentNotifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      state = AsyncValue.data(updatedNotifications);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.markAllNotificationsAsRead();

      // Update the local state
      final currentNotifications = state.valueOrNull ?? [];
      final updatedNotifications = currentNotifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList();

      state = AsyncValue.data(updatedNotifications);
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
}

@riverpod
Future<int> unreadNotificationsCount(Ref ref) async {
  try {
    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.getUnreadNotificationsCount();
    return (response['unread_count'] ?? 0) as int;
  } catch (e) {
    print('Error getting unread notifications count: $e');
    return 0;
  }
}
