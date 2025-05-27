// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$withdrawalListHash() => r'612ac934a88a6efc0b58cf61cc110ef2da7bba6d';

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

abstract class _$WithdrawalList
    extends BuildlessAutoDisposeAsyncNotifier<List<Withdrawal>> {
  late final int limit;
  late final int offset;

  FutureOr<List<Withdrawal>> build({
    int limit = 20,
    int offset = 0,
  });
}

/// See also [WithdrawalList].
@ProviderFor(WithdrawalList)
const withdrawalListProvider = WithdrawalListFamily();

/// See also [WithdrawalList].
class WithdrawalListFamily extends Family<AsyncValue<List<Withdrawal>>> {
  /// See also [WithdrawalList].
  const WithdrawalListFamily();

  /// See also [WithdrawalList].
  WithdrawalListProvider call({
    int limit = 20,
    int offset = 0,
  }) {
    return WithdrawalListProvider(
      limit: limit,
      offset: offset,
    );
  }

  @override
  WithdrawalListProvider getProviderOverride(
    covariant WithdrawalListProvider provider,
  ) {
    return call(
      limit: provider.limit,
      offset: provider.offset,
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
  String? get name => r'withdrawalListProvider';
}

/// See also [WithdrawalList].
class WithdrawalListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    WithdrawalList, List<Withdrawal>> {
  /// See also [WithdrawalList].
  WithdrawalListProvider({
    int limit = 20,
    int offset = 0,
  }) : this._internal(
          () => WithdrawalList()
            ..limit = limit
            ..offset = offset,
          from: withdrawalListProvider,
          name: r'withdrawalListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$withdrawalListHash,
          dependencies: WithdrawalListFamily._dependencies,
          allTransitiveDependencies:
              WithdrawalListFamily._allTransitiveDependencies,
          limit: limit,
          offset: offset,
        );

  WithdrawalListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final int limit;
  final int offset;

  @override
  FutureOr<List<Withdrawal>> runNotifierBuild(
    covariant WithdrawalList notifier,
  ) {
    return notifier.build(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Override overrideWith(WithdrawalList Function() create) {
    return ProviderOverride(
      origin: this,
      override: WithdrawalListProvider._internal(
        () => create()
          ..limit = limit
          ..offset = offset,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WithdrawalList, List<Withdrawal>>
      createElement() {
    return _WithdrawalListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WithdrawalListProvider &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WithdrawalListRef
    on AutoDisposeAsyncNotifierProviderRef<List<Withdrawal>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _WithdrawalListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WithdrawalList,
        List<Withdrawal>> with WithdrawalListRef {
  _WithdrawalListProviderElement(super.provider);

  @override
  int get limit => (origin as WithdrawalListProvider).limit;
  @override
  int get offset => (origin as WithdrawalListProvider).offset;
}

String _$withdrawalDetailHash() => r'a5ceab711f18a97c4ce7f8887ed58161297f2bc4';

abstract class _$WithdrawalDetail
    extends BuildlessAutoDisposeAsyncNotifier<Withdrawal> {
  late final int id;

  FutureOr<Withdrawal> build(
    int id,
  );
}

/// See also [WithdrawalDetail].
@ProviderFor(WithdrawalDetail)
const withdrawalDetailProvider = WithdrawalDetailFamily();

/// See also [WithdrawalDetail].
class WithdrawalDetailFamily extends Family<AsyncValue<Withdrawal>> {
  /// See also [WithdrawalDetail].
  const WithdrawalDetailFamily();

  /// See also [WithdrawalDetail].
  WithdrawalDetailProvider call(
    int id,
  ) {
    return WithdrawalDetailProvider(
      id,
    );
  }

  @override
  WithdrawalDetailProvider getProviderOverride(
    covariant WithdrawalDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'withdrawalDetailProvider';
}

/// See also [WithdrawalDetail].
class WithdrawalDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<WithdrawalDetail, Withdrawal> {
  /// See also [WithdrawalDetail].
  WithdrawalDetailProvider(
    int id,
  ) : this._internal(
          () => WithdrawalDetail()..id = id,
          from: withdrawalDetailProvider,
          name: r'withdrawalDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$withdrawalDetailHash,
          dependencies: WithdrawalDetailFamily._dependencies,
          allTransitiveDependencies:
              WithdrawalDetailFamily._allTransitiveDependencies,
          id: id,
        );

  WithdrawalDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<Withdrawal> runNotifierBuild(
    covariant WithdrawalDetail notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(WithdrawalDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: WithdrawalDetailProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WithdrawalDetail, Withdrawal>
      createElement() {
    return _WithdrawalDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WithdrawalDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WithdrawalDetailRef on AutoDisposeAsyncNotifierProviderRef<Withdrawal> {
  /// The parameter `id` of this provider.
  int get id;
}

class _WithdrawalDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WithdrawalDetail,
        Withdrawal> with WithdrawalDetailRef {
  _WithdrawalDetailProviderElement(super.provider);

  @override
  int get id => (origin as WithdrawalDetailProvider).id;
}

String _$withdrawalRequestHash() => r'366130281c1b48b8e0edd8eae1302e0421dfd10a';

/// See also [WithdrawalRequest].
@ProviderFor(WithdrawalRequest)
final withdrawalRequestProvider =
    AutoDisposeAsyncNotifierProvider<WithdrawalRequest, void>.internal(
  WithdrawalRequest.new,
  name: r'withdrawalRequestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$withdrawalRequestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WithdrawalRequest = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
