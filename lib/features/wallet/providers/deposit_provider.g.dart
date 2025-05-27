// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentDepositsHash() => r'5ed30e4cac30f5a48b84e1328487c365cccb7750';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RecentDeposits
    extends BuildlessAutoDisposeAsyncNotifier<List<Payment>> {
  late final int limit;

  FutureOr<List<Payment>> build({
    int limit = 5,
  });
}

/// See also [RecentDeposits].
@ProviderFor(RecentDeposits)
const recentDepositsProvider = RecentDepositsFamily();

/// See also [RecentDeposits].
class RecentDepositsFamily extends Family<AsyncValue<List<Payment>>> {
  /// See also [RecentDeposits].
  const RecentDepositsFamily();

  /// See also [RecentDeposits].
  RecentDepositsProvider call({
    int limit = 5,
  }) {
    return RecentDepositsProvider(
      limit: limit,
    );
  }

  @override
  RecentDepositsProvider getProviderOverride(
    covariant RecentDepositsProvider provider,
  ) {
    return call(
      limit: provider.limit,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentDepositsProvider';
}

/// See also [RecentDeposits].
class RecentDepositsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    RecentDeposits, List<Payment>> {
  /// See also [RecentDeposits].
  RecentDepositsProvider({
    int limit = 5,
  }) : this._internal(
          () => RecentDeposits()..limit = limit,
          from: recentDepositsProvider,
          name: r'recentDepositsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentDepositsHash,
          dependencies: RecentDepositsFamily._dependencies,
          allTransitiveDependencies:
              RecentDepositsFamily._allTransitiveDependencies,
          limit: limit,
        );

  RecentDepositsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  FutureOr<List<Payment>> runNotifierBuild(
    covariant RecentDeposits notifier,
  ) {
    return notifier.build(
      limit: limit,
    );
  }

  @override
  Override overrideWith(RecentDeposits Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecentDepositsProvider._internal(
        () => create()..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RecentDeposits, List<Payment>>
      createElement() {
    return _RecentDepositsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentDepositsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentDepositsRef on AutoDisposeAsyncNotifierProviderRef<List<Payment>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentDepositsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RecentDeposits,
        List<Payment>> with RecentDepositsRef {
  _RecentDepositsProviderElement(super.provider);

  @override
  int get limit => (origin as RecentDepositsProvider).limit;
}

String _$coinGateDepositHash() => r'7267f81210abe9b4a585f833bc2c61ea709dadf0';

/// See also [CoinGateDeposit].
@ProviderFor(CoinGateDeposit)
final coinGateDepositProvider =
    AutoDisposeAsyncNotifierProvider<CoinGateDeposit, void>.internal(
  CoinGateDeposit.new,
  name: r'coinGateDepositProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$coinGateDepositHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CoinGateDeposit = AutoDisposeAsyncNotifier<void>;
String _$uddoktapayDepositHash() => r'df1248f3b185759542990dbf3f8cc45f2507f6d3';

/// See also [UddoktapayDeposit].
@ProviderFor(UddoktapayDeposit)
final uddoktapayDepositProvider =
    AutoDisposeAsyncNotifierProvider<UddoktapayDeposit, void>.internal(
  UddoktapayDeposit.new,
  name: r'uddoktapayDepositProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uddoktapayDepositHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UddoktapayDeposit = AutoDisposeAsyncNotifier<void>;
String _$manualDepositHash() => r'baadcfb54f5bd55ca58101810a752bc5cb1c9087';

/// See also [ManualDeposit].
@ProviderFor(ManualDeposit)
final manualDepositProvider =
    AutoDisposeAsyncNotifierProvider<ManualDeposit, void>.internal(
  ManualDeposit.new,
  name: r'manualDepositProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$manualDepositHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ManualDeposit = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
