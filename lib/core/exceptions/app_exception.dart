// lib/core/exceptions/app_exception.dart
class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => message;
}
