// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'82cee5422e4b74dcb860c768c5535bdde927a0a5';

/// See also [Transactions].
@ProviderFor(Transactions)
final transactionsProvider =
    AutoDisposeAsyncNotifierProvider<Transactions, List<Transaction>>.internal(
  Transactions.new,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Transactions = AutoDisposeAsyncNotifier<List<Transaction>>;
String _$depositHash() => r'6f15eb789dd604d4a9a0ea60067b868dc2d69e70';

/// See also [Deposit].
@ProviderFor(Deposit)
final depositProvider =
    AutoDisposeAsyncNotifierProvider<Deposit, void>.internal(
  Deposit.new,
  name: r'depositProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$depositHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Deposit = AutoDisposeAsyncNotifier<void>;
String _$withdrawalHash() => r'7ee1734df9c21950deacc31f76c89abc607d9072';

/// See also [Withdrawal].
@ProviderFor(Withdrawal)
final withdrawalProvider =
    AutoDisposeAsyncNotifierProvider<Withdrawal, void>.internal(
  Withdrawal.new,
  name: r'withdrawalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$withdrawalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Withdrawal = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
