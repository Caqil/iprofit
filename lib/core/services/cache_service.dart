// lib/core/services/cache_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../models/transaction.dart';
import '../../models/notification.dart';

class CacheService {
  static const String _homeDataKey = 'home_data';
  static const String _userDataKey = 'user_data';
  static const String _notificationsKey = 'notifications_data';
  static const String _lastUpdateKey = 'last_update_';

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Generic cache methods
  Future<void> _setString(String key, String value) async {
    await init();
    await _prefs.setString(key, value);
    await _prefs.setInt(
      '${_lastUpdateKey}$key',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  String? _getString(String key) {
    if (!_initialized) return null;
    return _prefs.getString(key);
  }

  Future<void> _remove(String key) async {
    await init();
    await _prefs.remove(key);
    await _prefs.remove('${_lastUpdateKey}$key');
  }

  DateTime? _getLastUpdate(String key) {
    if (!_initialized) return null;
    final timestamp = _prefs.getInt('${_lastUpdateKey}$key');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  bool _isCacheValid(
    String key, {
    Duration maxAge = const Duration(minutes: 15),
  }) {
    final lastUpdate = _getLastUpdate(key);
    if (lastUpdate == null) return false;
    return DateTime.now().difference(lastUpdate) < maxAge;
  }

  // User data caching
  Future<void> saveUserData(User user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _setString(_userDataKey, userJson);
      print('✅ User data cached successfully');
    } catch (e) {
      print('❌ Failed to cache user data: $e');
    }
  }

  User? getCachedUserData() {
    try {
      final userJson = _getString(_userDataKey);
      if (userJson != null) {
        final userData = json.decode(userJson);
        print('✅ User data loaded from cache');
        return User.fromJson(userData);
      }
    } catch (e) {
      print('❌ Failed to load cached user data: $e');
    }
    return null;
  }

  bool isUserDataValid() => _isCacheValid(_userDataKey);

  // Home data caching
  Future<void> saveHomeData(Map<String, dynamic> homeData) async {
    try {
      // Convert models to JSON-serializable format
      final cacheData = {
        'user': homeData['user']?.toJson(),
        'dashboardStats': homeData['dashboardStats'],
        'profitData': homeData['profitData']
            ?.map(
              (profit) => {
                'date': profit.date.toIso8601String(),
                'amount': profit.amount,
              },
            )
            ?.toList(),
        'recentTransactions': homeData['recentTransactions']
            ?.map((transaction) => transaction.toJson())
            ?.toList(),
        'tasksProgress': homeData['tasksProgress']
            ?.map(
              (task) => {
                'title': task.title,
                'isCompleted': task.isCompleted,
                'status': task.status,
                'taskType': task.taskType.toString(),
                'isMandatory': task.isMandatory,
              },
            )
            ?.toList(),
        'referralLeaderboard': homeData['referralLeaderboard']
            ?.map(
              (item) => {
                'name': item.name,
                'avatar': item.avatar,
                'referralCount': item.referralCount,
                'earnings': item.earnings,
                'isCurrentUser': item.isCurrentUser,
              },
            )
            ?.toList(),
      };

      final homeJson = json.encode(cacheData);
      await _setString(_homeDataKey, homeJson);
      print('✅ Home data cached successfully');
    } catch (e) {
      print('❌ Failed to cache home data: $e');
    }
  }

  Map<String, dynamic>? getCachedHomeData() {
    try {
      final homeJson = _getString(_homeDataKey);
      if (homeJson != null) {
        final homeData = json.decode(homeJson);
        print('✅ Home data loaded from cache');

        // Convert back to models if needed
        return {
          'user': homeData['user'] != null
              ? User.fromJson(homeData['user'])
              : null,
          'dashboardStats': homeData['dashboardStats'],
          'profitData': homeData['profitData']
              ?.map(
                (profit) => ProfitData(
                  date: DateTime.parse(profit['date']),
                  amount: profit['amount']?.toDouble() ?? 0.0,
                ),
              )
              ?.toList(),
          'recentTransactions': homeData['recentTransactions']
              ?.map((transaction) => Transaction.fromJson(transaction))
              ?.toList(),
          'tasksProgress': homeData['tasksProgress'],
          'referralLeaderboard': homeData['referralLeaderboard'],
        };
      }
    } catch (e) {
      print('❌ Failed to load cached home data: $e');
    }
    return null;
  }

  bool isHomeDataValid() => _isCacheValid(_homeDataKey);

  // Notifications caching
  Future<void> saveNotifications(List<AppNotification> notifications) async {
    try {
      final notificationsJson = json.encode(
        notifications.map((notification) => notification.toJson()).toList(),
      );
      await _setString(_notificationsKey, notificationsJson);
      print('✅ Notifications cached successfully');
    } catch (e) {
      print('❌ Failed to cache notifications: $e');
    }
  }

  List<AppNotification>? getCachedNotifications() {
    try {
      final notificationsJson = _getString(_notificationsKey);
      if (notificationsJson != null) {
        final notificationsList = json.decode(notificationsJson) as List;
        print('✅ Notifications loaded from cache');
        return notificationsList
            .map((notification) => AppNotification.fromJson(notification))
            .toList();
      }
    } catch (e) {
      print('❌ Failed to load cached notifications: $e');
    }
    return null;
  }

  bool isNotificationsValid() => _isCacheValid(_notificationsKey);

  // Cache management
  Future<void> clearCache() async {
    await init();
    await _remove(_homeDataKey);
    await _remove(_userDataKey);
    await _remove(_notificationsKey);
    print('🗑️ Cache cleared successfully');
  }

  Future<void> clearUserCache() async {
    await _remove(_userDataKey);
    await _remove(_homeDataKey);
    await _remove(_notificationsKey);
    print('🗑️ User cache cleared');
  }

  // Cache info
  Map<String, dynamic> getCacheInfo() {
    return {
      'homeData': {
        'exists': getCachedHomeData() != null,
        'lastUpdate': _getLastUpdate(_homeDataKey)?.toIso8601String(),
        'isValid': isHomeDataValid(),
      },
      'userData': {
        'exists': getCachedUserData() != null,
        'lastUpdate': _getLastUpdate(_userDataKey)?.toIso8601String(),
        'isValid': isUserDataValid(),
      },
      'notifications': {
        'exists': getCachedNotifications() != null,
        'lastUpdate': _getLastUpdate(_notificationsKey)?.toIso8601String(),
        'isValid': isNotificationsValid(),
      },
    };
  }
}

// ProfitData class (if not defined elsewhere)
class ProfitData {
  final DateTime date;
  final double amount;

  ProfitData({required this.date, required this.amount});
}
