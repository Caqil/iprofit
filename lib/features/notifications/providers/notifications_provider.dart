// lib/features/notifications/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/notifications_repository.dart';
import '../../../models/notification.dart';
import '../../../providers/global_providers.dart';

part 'notifications_provider.g.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class Notifications extends _$Notifications {
  @override
  Future<List<AppNotification>> build() async {
    return ref.watch(notificationsRepositoryProvider).getNotifications();
  }

  Future<void> markAsRead(int id) async {
    try {
      await ref
          .read(notificationsRepositoryProvider)
          .markNotificationAsRead(id);

      // Update the local notification list
      final currentNotifications = state.valueOrNull ?? [];

      state = AsyncValue.data(
        currentNotifications.map((notification) {
          if (notification.id == id) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList(),
      );

      // Update unread count
      ref.invalidate(unreadNotificationsCountProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await ref
          .read(notificationsRepositoryProvider)
          .markAllNotificationsAsRead();

      // Update all notifications in the list to read
      final currentNotifications = state.valueOrNull ?? [];

      state = AsyncValue.data(
        currentNotifications.map((notification) {
          return notification.copyWith(isRead: true);
        }).toList(),
      );

      // Update unread count
      ref.invalidate(unreadNotificationsCountProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final notifications = await ref
          .read(notificationsRepositoryProvider)
          .getNotifications();
      state = AsyncValue.data(notifications);

      // Refresh unread count as well
      ref.invalidate(unreadNotificationsCountProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

@riverpod
Future<int> unreadNotificationsCount(UnreadNotificationsCountRef ref) async {
  return ref
      .watch(notificationsRepositoryProvider)
      .getUnreadNotificationsCount();
}
