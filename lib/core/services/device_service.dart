// lib/core/services/device_service.dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../constants/storage_keys.dart';

final deviceServiceProvider = Provider(
  (ref) => DeviceService(const FlutterSecureStorage(), DeviceInfoPlugin()),
);

class DeviceService {
  final FlutterSecureStorage _secureStorage;
  final DeviceInfoPlugin _deviceInfo;
  final _uuid = const Uuid();

  DeviceService(this._secureStorage, this._deviceInfo);

  Future<String> getDeviceId() async {
    // Try to get existing device ID
    String? deviceId = await _secureStorage.read(key: StorageKeys.deviceId);

    // If no device ID exists, generate a new one
    if (deviceId == null) {
      deviceId = _uuid.v4();
      await _secureStorage.write(key: StorageKeys.deviceId, value: deviceId);
    }

    return deviceId;
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    // Get device info based on platform
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return {
        'device_name': info.model,
        'device_model': '${info.manufacturer} ${info.model}',
      };
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return {
        'device_name': info.name,
        'device_model': '${info.systemName} ${info.systemVersion}',
      };
    }

    return {'device_name': 'Unknown', 'device_model': 'Unknown'};
  }
}
