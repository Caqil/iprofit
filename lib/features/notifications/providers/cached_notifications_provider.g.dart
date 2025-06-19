// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationsCountHash() =>
    r'21bdd7430d67c7485c11d34a09c1353261312462';

/// Provider for unread notifications count
///
/// Copied from [unreadNotificationsCount].
@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider = AutoDisposeProvider<int>.internal(
  unreadNotificationsCount,
  name: r'unreadNotificationsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationsCountRef = AutoDisposeProviderRef<int>;
String _$cachedNotificationsHash() =>
    r'4a573ab473ff5cc98c6ed50668c38feefd68eb75';

/// See also [CachedNotifications].
@ProviderFor(CachedNotifications)
final cachedNotificationsProvider = AutoDisposeAsyncNotifierProvider<
    CachedNotifications, List<AppNotification>>.internal(
  CachedNotifications.new,
  name: r'cachedNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cachedNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CachedNotifications = AutoDisposeAsyncNotifier<List<AppNotification>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
