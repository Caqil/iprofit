// lib/repositories/base_repository.dart
import 'package:dio/dio.dart';
import '../core/exceptions/api_exception.dart';
import '../core/exceptions/auth_exception.dart';
import '../core/exceptions/app_exception.dart';

class BaseRepository {
  // Safe API call wrapper to handle exceptions
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      // Handle different DioError types
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw ApiException(
            message:
                'Connection timeout. Please check your internet connection.',
            statusCode: 408,
          );
        case DioExceptionType.badCertificate:
          throw ApiException(
            message: 'SSL Certificate verification failed',
            statusCode: 495,
          );
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode ?? 500;
          String errorMessage =
              'Error occurred while communicating with server';

          // Try to extract error message from response
          if (e.response?.data != null &&
              e.response!.data is Map<String, dynamic>) {
            final data = e.response!.data as Map<String, dynamic>;
            if (data.containsKey('error')) {
              errorMessage = data['error'];
            } else if (data.containsKey('message')) {
              errorMessage = data['message'];
            }
          }

          // Handle common status codes
          if (statusCode == 401) {
            throw AuthException(
              message: 'Authentication failed. Please login again.',
            );
          } else if (statusCode == 403) {
            throw AuthException(
              message: 'You do not have permission to access this resource.',
            );
          } else if (statusCode == 404) {
            throw ApiException(
              message: 'Resource not found',
              statusCode: statusCode,
            );
          } else if (statusCode >= 500) {
            throw ApiException(
              message: 'Server error. Please try again later.',
              statusCode: statusCode,
            );
          }

          throw ApiException(message: errorMessage, statusCode: statusCode);
        case DioExceptionType.connectionError:
          throw ApiException(
            message: 'No internet connection. Please check your network.',
            statusCode: 0,
          );
        case DioExceptionType.cancel:
          throw ApiException(message: 'Request was cancelled', statusCode: 499);
        case DioExceptionType.unknown:
        default:
          throw ApiException(
            message: e.message ?? 'An unexpected error occurred',
            statusCode: 500,
          );
      }
    } catch (e) {
      if (e is ApiException || e is AuthException) {
        rethrow;
      }

      // Handle generic errors
      throw AppException(message: e.toString());
    }
  }

  // Helper method to parse common API responses
  Map<String, dynamic> parseResponse(
    Map<String, dynamic> response,
    String dataKey,
  ) {
    if (!response.containsKey(dataKey)) {
      throw ApiException(
        message: 'Invalid response format: missing $dataKey',
        statusCode: 500,
      );
    }

    return response[dataKey];
  }

  // Helper method to parse list responses
  List<Map<String, dynamic>> parseListResponse(
    Map<String, dynamic> response,
    String dataKey,
  ) {
    if (!response.containsKey(dataKey)) {
      throw ApiException(
        message: 'Invalid response format: missing $dataKey',
        statusCode: 500,
      );
    }

    return (response[dataKey] as List).cast<Map<String, dynamic>>();
  }

  // Helper method to check for success response
  bool isSuccessResponse(Map<String, dynamic> response) {
    return response.containsKey('message') &&
        (response.containsKey('success') ? response['success'] == true : true);
  }
}
