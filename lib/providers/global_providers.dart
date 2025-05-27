// lib/providers/global_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/services/dio_client.dart';
import '../core/services/storage_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/device_service.dart';
import '../core/services/biometric_service.dart';
import '../core/services/api_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth/local_auth.dart';

// Core service providers
final dioProvider = Provider<Dio>((ref) {
  return DioClient.getInstance();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService(ref.watch(secureStorageProvider), DeviceInfoPlugin());
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService(LocalAuthentication());
});


// App state providers
final isLoadingProvider = StateProvider<bool>((ref) => false);
final appErrorProvider = StateProvider<String?>((ref) => null);

// Global app settings
final isDarkModeProvider = StateProvider<bool>((ref) => false);
