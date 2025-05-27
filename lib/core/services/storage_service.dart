// lib/core/services/storage_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Create a provider to determine if the storage service is initialized
final storageInitializedProvider = StateProvider<bool>((ref) => false);

final storageServiceProvider = Provider((ref) => StorageService());

class StorageService {
  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;
  bool _initialized = false;

  // Check if storage is initialized
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Secure storage methods
  Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  // SharedPreferences methods
  Future<void> saveString(String key, String value) async {
    await _ensureInitialized();
    await _prefs!.setString(key, value);
  }

  String? getString(String key) {
    if (!_initialized) return null;
    return _prefs!.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _ensureInitialized();
    await _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    if (!_initialized) return null;
    return _prefs!.getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    if (!_initialized) return null;
    return _prefs!.getBool(key);
  }

  Future<void> saveObject(String key, Map<String, dynamic> value) async {
    await _ensureInitialized();
    await _prefs!.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getObject(String key) {
    if (!_initialized) return null;
    final data = _prefs!.getString(key);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> remove(String key) async {
    await _ensureInitialized();
    await _prefs!.remove(key);
  }

  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  // Helper method to ensure initialization
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }
}
