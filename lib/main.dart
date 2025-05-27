// lib/main.dart - Updated with easy_localization
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app/app.dart';
import 'core/services/storage_service.dart';
import 'core/constants/storage_keys.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:uuid/uuid.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize easy_localization
  await EasyLocalization.ensureInitialized();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  // Generate device ID if not already stored
  final secureStorage = const FlutterSecureStorage();
  String? deviceId = await secureStorage.read(key: StorageKeys.deviceId);

  if (deviceId == null) {
    // Generate a new device ID
    deviceId = const Uuid().v4();

    // Get device info to enhance the device ID
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final androidId = androidInfo.id;
        deviceId = '$deviceId-android-$androidId';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        final identifierForVendor = iosInfo.identifierForVendor;
        deviceId = '$deviceId-ios-$identifierForVendor';
      }
    } catch (e) {
      // Fallback to just UUID if device info retrieval fails
      print('Failed to get device info: $e');
    }

    // Store the device ID
    await secureStorage.write(key: StorageKeys.deviceId, value: deviceId);
  }

  // Run the app with EasyLocalization wrapper
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('bn', 'BD'), // Bengali for BDT users
        Locale('hi', 'IN'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('pt', 'PT'),
        Locale('ar', 'SA'),
        Locale('zh', 'CN'),
        Locale('de', 'DE'),
        Locale('ru', 'RU'),
        Locale('ja', 'JP'),
      ],
      useOnlyLangCode: true,
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: ProviderScope(
        overrides: [
          // Override the storage service provider with our initialized instance
          storageServiceProvider.overrideWithValue(storageService),
        ],
        child: const InvestmentApp(),
      ),
    ),
  );
}
