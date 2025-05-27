// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionListHash() => r'8f60b192066af9f833e2a2d25703377e4aba8005';

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

abstract class _$TransactionList
    extends BuildlessAutoDisposeAsyncNotifier<List<Transaction>> {
  late final int limit;
  late final int offset;

  FutureOr<List<Transaction>> build({
    int limit = 20,
    int offset = 0,
  });
}

/// See also [TransactionList].
@ProviderFor(TransactionList)
const transactionListProvider = TransactionListFamily();

/// See also [TransactionList].
class TransactionListFamily extends Family<AsyncValue<List<Transaction>>> {
  /// See also [TransactionList].
  const TransactionListFamily();

  /// See also [TransactionList].
  TransactionListProvider call({
    int limit = 20,
    int offset = 0,
  }) {
    return TransactionListProvider(
      limit: limit,
      offset: offset,
    );
  }

  @override
  TransactionListProvider getProviderOverride(
    covariant TransactionListProvider provider,
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
  String? get name => r'transactionListProvider';
}

/// See also [TransactionList].
class TransactionListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TransactionList, List<Transaction>> {
  /// See also [TransactionList].
  TransactionListProvider({
    int limit = 20,
    int offset = 0,
  }) : this._internal(
          () => TransactionList()
            ..limit = limit
            ..offset = offset,
          from: transactionListProvider,
          name: r'transactionListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionListHash,
          dependencies: TransactionListFamily._dependencies,
          allTransitiveDependencies:
              TransactionListFamily._allTransitiveDependencies,
          limit: limit,
          offset: offset,
        );

  TransactionListProvider._internal(
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
  FutureOr<List<Transaction>> runNotifierBuild(
    covariant TransactionList notifier,
  ) {
    return notifier.build(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Override overrideWith(TransactionList Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TransactionList, List<Transaction>>
      createElement() {
    return _TransactionListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionListProvider &&
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
mixin TransactionListRef
    on AutoDisposeAsyncNotifierProviderRef<List<Transaction>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _TransactionListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TransactionList,
        List<Transaction>> with TransactionListRef {
  _TransactionListProviderElement(super.provider);

  @override
  int get limit => (origin as TransactionListProvider).limit;
  @override
  int get offset => (origin as TransactionListProvider).offset;
}

String _$transactionDetailHash() => r'0c6d848d22542a0cc6979074abf8b159122a23ad';

abstract class _$TransactionDetail
    extends BuildlessAutoDisposeAsyncNotifier<Transaction> {
  late final int id;

  FutureOr<Transaction> build(
    int id,
  );
}

/// See also [TransactionDetail].
@ProviderFor(TransactionDetail)
const transactionDetailProvider = TransactionDetailFamily();

/// See also [TransactionDetail].
class TransactionDetailFamily extends Family<AsyncValue<Transaction>> {
  /// See also [TransactionDetail].
  const TransactionDetailFamily();

  /// See also [TransactionDetail].
  TransactionDetailProvider call(
    int id,
  ) {
    return TransactionDetailProvider(
      id,
    );
  }

  @override
  TransactionDetailProvider getProviderOverride(
    covariant TransactionDetailProvider provider,
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
  String? get name => r'transactionDetailProvider';
}

/// See also [TransactionDetail].
class TransactionDetailProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TransactionDetail, Transaction> {
  /// See also [TransactionDetail].
  TransactionDetailProvider(
    int id,
  ) : this._internal(
          () => TransactionDetail()..id = id,
          from: transactionDetailProvider,
          name: r'transactionDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionDetailHash,
          dependencies: TransactionDetailFamily._dependencies,
          allTransitiveDependencies:
              TransactionDetailFamily._allTransitiveDependencies,
          id: id,
        );

  TransactionDetailProvider._internal(
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
  FutureOr<Transaction> runNotifierBuild(
    covariant TransactionDetail notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(TransactionDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionDetailProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TransactionDetail, Transaction>
      createElement() {
    return _TransactionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionDetailProvider && other.id == id;
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
mixin TransactionDetailRef on AutoDisposeAsyncNotifierProviderRef<Transaction> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TransactionDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TransactionDetail,
        Transaction> with TransactionDetailRef {
  _TransactionDetailProviderElement(super.provider);

  @override
  int get id => (origin as TransactionDetailProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
