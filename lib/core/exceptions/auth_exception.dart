// lib/core/exceptions/auth_exception.dart
class AuthException implements Exception {
  final String message;

  AuthException({required this.message});

  @override
  String toString() => message;
}
