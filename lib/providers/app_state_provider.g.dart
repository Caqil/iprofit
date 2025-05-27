// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityHash() => r'69c6e2db8337a9ff832358c4a079a4846fa6f28c';

/// See also [connectivity].
@ProviderFor(connectivity)
final connectivityProvider =
    AutoDisposeStreamProvider<List<ConnectivityResult>>.internal(
  connectivity,
  name: r'connectivityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$connectivityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityRef
    = AutoDisposeStreamProviderRef<List<ConnectivityResult>>;
String _$isConnectedHash() => r'50eceb168857b44cf9d4a3490008cf84292bc012';

/// See also [isConnected].
@ProviderFor(isConnected)
final isConnectedProvider = AutoDisposeFutureProvider<bool>.internal(
  isConnected,
  name: r'isConnectedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsConnectedRef = AutoDisposeFutureProviderRef<bool>;
String _$appThemeHash() => r'10af92a510d5646aef17f48395836abe58bbd92d';

/// See also [AppTheme].
@ProviderFor(AppTheme)
final appThemeProvider =
    AutoDisposeNotifierProvider<AppTheme, AppThemeMode>.internal(
  AppTheme.new,
  name: r'appThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppTheme = AutoDisposeNotifier<AppThemeMode>;
String _$appLocaleHash() => r'cd4aca93420fa5773c3ea2647bc486691f889c09';

/// See also [AppLocale].
@ProviderFor(AppLocale)
final appLocaleProvider =
    AutoDisposeNotifierProvider<AppLocale, AppLanguage>.internal(
  AppLocale.new,
  name: r'appLocaleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppLocale = AutoDisposeNotifier<AppLanguage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
