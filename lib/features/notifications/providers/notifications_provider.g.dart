// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationsCountHash() =>
    r'cf5a7189e5ba07e84674a778705b8e4f0479fae1';

/// See also [unreadNotificationsCount].
@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider =
    AutoDisposeFutureProvider<int>.internal(
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
typedef UnreadNotificationsCountRef = AutoDisposeFutureProviderRef<int>;
String _$notificationsHash() => r'375ff4eda4c0806de6f6734c66f83b0ae3392284';

/// See also [Notifications].
@ProviderFor(Notifications)
final notificationsProvider = AutoDisposeAsyncNotifierProvider<Notifications,
    List<AppNotification>>.internal(
  Notifications.new,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Notifications = AutoDisposeAsyncNotifier<List<AppNotification>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
