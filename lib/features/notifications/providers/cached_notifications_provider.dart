
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/notification.dart';
import '../../../providers/global_providers.dart';
import '../../home/providers/cached_home_provider.dart';

part 'cached_notifications_provider.g.dart';

@riverpod
class CachedNotifications extends _$CachedNotifications {
  @override
  Future<List<AppNotification>> build() async {
    return _loadNotifications();
  }

  /// Load notifications - first from cache, then from API if needed
  Future<List<AppNotification>> _loadNotifications() async {
    final cacheService = ref.read(cacheServiceProvider);

    // Try to load from cache first
    final cachedNotifications = cacheService.getCachedNotifications();

    if (cachedNotifications != null && cacheService.isNotificationsValid()) {
      print('📱 Loading notifications from cache (no loading state)');

      // Start background refresh
      _backgroundRefresh();

      return cachedNotifications;
    }

    // Check if we have expired cache to show while loading
    if (cachedNotifications != null) {
      print('📱 Using expired notification cache while fetching fresh data');

      // Set state to cached data immediately
      Future.microtask(() {
        state = AsyncData(cachedNotifications);
      });

      // Fetch fresh data in background
      _backgroundRefresh();

      return cachedNotifications;
    }

    // No cache at all - fetch from API (first time)
    print('🌐 No notification cache, fetching from API (first time)');
    return await _fetchFromAPI();
  }

  /// Background refresh without changing loading state
  void _backgroundRefresh() {
    Future.delayed(Duration.zero, () async {
      try {
        print('🔄 Background notification refresh started');
        final freshNotifications = await _fetchFromAPI();

        // Update state with fresh data
        state = AsyncData(freshNotifications);
        print('✅ Background notification refresh completed');
      } catch (e) {
        print('❌ Background notification refresh failed: $e');
        // Don't change state on background refresh error
      }
    });
  }

  /// Fetch notifications from API and cache them
  Future<List<AppNotification>> _fetchFromAPI() async {
    final apiClient = ref.read(apiClientProvider);
    final cacheService = ref.read(cacheServiceProvider);

    try {
      List<AppNotification> notifications;

      try {
        final response = await apiClient.getNotifications(limit: 50);
        final List<dynamic> notificationData = response['notifications'] ?? [];
        notifications = notificationData
            .map((json) => AppNotification.fromJson(json))
            .toList();
      } catch (e) {
        print('Primary notifications endpoint failed, trying fallback: $e');
        // Fallback to user notifications endpoint
        final response = await apiClient.getUserNotifications(limit: 50);
        final List<dynamic> notificationData = response['notifications'] ?? [];
        notifications = notificationData
            .map((json) => AppNotification.fromJson(json))
            .toList();
      }

      // Cache the notifications for next time
      await cacheService.saveNotifications(notifications);
      print('✅ Notifications fetched and cached');

      return notifications;
    } catch (e) {
      print('❌ Error fetching notifications: $e');

      // If API fails, try to return cached data even if expired
      final cachedNotifications = cacheService.getCachedNotifications();
      if (cachedNotifications != null) {
        print('📱 API failed, using expired notification cache');
        return cachedNotifications;
      }

      // If no cache available, return empty list instead of throwing
      print('📱 No cache available, returning empty notifications list');
      return [];
    }
  }

  /// Refresh notifications from API (for pull-to-refresh)
  Future<void> refresh() async {
    print('🔄 Refreshing notifications...');

    try {
      // Fetch fresh data from API
      final freshNotifications = await _fetchFromAPI();

      // Update the state with fresh data
      state = AsyncData(freshNotifications);
      print('✅ Notifications refreshed successfully');
    } catch (e) {
      print('❌ Failed to refresh notifications: $e');
      // Don't update state on error - keep existing data
      rethrow;
    }
  }

  /// Mark notification as read
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
          return AppNotification(
            id: notification.id,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            isRead: true, // Mark as read
            createdAt: notification.createdAt,
          );
        }
        return notification;
      }).toList();

      // Update state and cache
      state = AsyncData(updatedNotifications);
      final cacheService = ref.read(cacheServiceProvider);
      await cacheService.saveNotifications(updatedNotifications);

      print('✅ Notification $notificationId marked as read');
    } catch (e, st) {
      print('❌ Failed to mark notification as read: $e');
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.markAllNotificationsAsRead();

      // Update local state
      final currentNotifications = state.valueOrNull ?? [];
      final updatedNotifications = currentNotifications.map((notification) {
        return AppNotification(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          type: notification.type,
          isRead: true, // Mark all as read
          createdAt: notification.createdAt,
        );
      }).toList();

      // Update state and cache
      state = AsyncData(updatedNotifications);
      final cacheService = ref.read(cacheServiceProvider);
      await cacheService.saveNotifications(updatedNotifications);

      print('✅ All notifications marked as read');
    } catch (e, st) {
      print('❌ Failed to mark all notifications as read: $e');
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Get unread notifications count
  int getUnreadCount() {
    final notifications = state.valueOrNull ?? [];
    return notifications.where((notification) => !notification.isRead).length;
  }

  /// Check if we have any cached notifications
  bool hasData() {
    if (state.valueOrNull != null) return true;

    final cacheService = ref.read(cacheServiceProvider);
    return cacheService.getCachedNotifications() != null;
  }
}

/// Provider for unread notifications count
@riverpod
int unreadNotificationsCount(UnreadNotificationsCountRef ref) {
  final notificationsState = ref.watch(cachedNotificationsProvider);

  return notificationsState.when(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    loading: () {
      // Try to get count from cache while loading
      final cacheService = ref.read(cacheServiceProvider);
      final cachedNotifications = cacheService.getCachedNotifications();
      if (cachedNotifications != null) {
        return cachedNotifications.where((n) => !n.isRead).length;
      }
      return 0;
    },
    error: (_, __) => 0,
  );
}
