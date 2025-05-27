// lib/providers/app_state_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/services/storage_service.dart';
import '../core/constants/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_state_provider.g.dart';

// Theme provider
enum AppThemeMode { light, dark, system }

@riverpod
class AppTheme extends _$AppTheme {
  @override
  AppThemeMode build() {
    final storageService = ref.read(storageServiceProvider);
    final String? themeString = storageService.getString(StorageKeys.theme);

    if (themeString == null) {
      return AppThemeMode.system;
    }

    return AppThemeMode.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.saveString(StorageKeys.theme, mode.name);
    state = mode;
  }

  ThemeMode getThemeMode() {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

// Language provider
enum AppLanguage { english, bengali, hindi, arabic }

@riverpod
class AppLocale extends _$AppLocale {
  @override
  AppLanguage build() {
    final storageService = ref.read(storageServiceProvider);
    final String? languageString = storageService.getString(
      StorageKeys.language,
    );

    if (languageString == null) {
      return AppLanguage.english;
    }

    return AppLanguage.values.firstWhere(
      (e) => e.name == languageString,
      orElse: () => AppLanguage.english,
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.saveString(StorageKeys.language, language.name);
    state = language;
  }

  Locale getLocale() {
    switch (state) {
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.bengali:
        return const Locale('bn', 'BD');
      case AppLanguage.hindi:
        return const Locale('hi', 'IN');
      case AppLanguage.arabic:
        return const Locale('ar', 'SA');
    }
  }
}

// Network connectivity provider
@riverpod
Stream<List<ConnectivityResult>> connectivity(Ref ref) {
  return Connectivity().onConnectivityChanged;
}

@riverpod
Future<bool> isConnected(Ref ref) async {
  final connectivity = await Connectivity().checkConnectivity();
  return connectivity != ConnectivityResult.none;
}
