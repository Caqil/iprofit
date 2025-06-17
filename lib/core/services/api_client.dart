// lib/core/services/api_client.dart - UPDATED VERSION
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;

  ApiClient(this._dio, {String? baseUrl})
    : baseUrl = baseUrl ?? ApiConstants.baseUrl;

  // Generic HTTP methods
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.get(
      '$baseUrl$path',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('$baseUrl$path', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put('$baseUrl$path', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.patch('$baseUrl$path', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await _dio.delete('$baseUrl$path', data: body);
    return response.data as Map<String, dynamic>;
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    return post(ApiConstants.login, body);
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    return post(ApiConstants.register, body);
  }

  Future<Map<String, dynamic>> verifyEmail(Map<String, dynamic> body) async {
    return post(ApiConstants.verifyEmail, body);
  }

  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> body) async {
    return post(ApiConstants.forgotPassword, body);
  }

  // User endpoints
  Future<Map<String, dynamic>> getProfile() async {
    return get(ApiConstants.profile);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) async {
    return put(ApiConstants.updateProfile, body);
  }

  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> body) async {
    return put(ApiConstants.changePassword, body);
  }

  Future<Map<String, dynamic>> enableBiometric() async {
    return post(ApiConstants.enableBiometric, {});
  }

  // NEW: Disable biometric endpoint
  Future<Map<String, dynamic>> disableBiometric() async {
    return put('/user/disable-biometric', {});
  }

  // NEW: Delete account endpoint
  Future<Map<String, dynamic>> deleteAccount() async {
    return delete('/user/profile');
  }

  // Plan endpoints
  Future<Map<String, dynamic>> getPlans() async {
    return get(ApiConstants.plans);
  }

  Future<Map<String, dynamic>> purchasePlan(int id) async {
    return post('/plans/$id/purchase', {});
  }

  // Deposit endpoints
  Future<Map<String, dynamic>> depositViaCoingate(
    Map<String, dynamic> body,
  ) async {
    return post(ApiConstants.depositCoingate, body);
  }

  Future<Map<String, dynamic>> depositViaUddoktapay(
    Map<String, dynamic> body,
  ) async {
    return post(ApiConstants.depositUddoktapay, body);
  }

  Future<Map<String, dynamic>> depositViaManual(
    Map<String, dynamic> body,
  ) async {
    return post(ApiConstants.depositManual, body);
  }

  // Withdrawal endpoints
  Future<Map<String, dynamic>> getWithdrawals() async {
    return get(ApiConstants.withdrawals);
  }

  Future<Map<String, dynamic>> requestWithdrawal(
    Map<String, dynamic> body,
  ) async {
    return post(ApiConstants.withdrawals, body);
  }

  // Transaction endpoints
  Future<Map<String, dynamic>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    return get(ApiConstants.transactions, queryParams: queryParams);
  }

  // Task endpoints
  Future<Map<String, dynamic>> getTasks() async {
    return get(ApiConstants.tasks);
  }

  Future<Map<String, dynamic>> completeTask(int id) async {
    return post('/tasks/$id/complete', {});
  }

  // Referral endpoints
  Future<Map<String, dynamic>> getReferrals() async {
    return get(ApiConstants.referrals);
  }

  Future<Map<String, dynamic>> getReferralEarnings() async {
    return get(ApiConstants.referralEarnings);
  }

  // KYC endpoints
  Future<Map<String, dynamic>> submitKyc(Map<String, dynamic> body) async {
    return post(ApiConstants.kycSubmit, body);
  }

  Future<Map<String, dynamic>> getKycStatus() async {
    return get(ApiConstants.kycStatus);
  }

  // Notification endpoints
  Future<Map<String, dynamic>> getNotifications({
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    return get(ApiConstants.notifications, queryParams: queryParams);
  }

  Future<Map<String, dynamic>> getUnreadNotificationsCount() async {
    return get(ApiConstants.unreadNotifications);
  }

  Future<Map<String, dynamic>> markNotificationAsRead(int id) async {
    return put('/notifications/$id/read', {});
  }

  Future<Map<String, dynamic>> markAllNotificationsAsRead() async {
    return put(ApiConstants.markAllNotificationsRead, {});
  }

  // User notifications (alternative route from Go)
  Future<Map<String, dynamic>> getUserNotifications({
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    return get(ApiConstants.userNotifications, queryParams: queryParams);
  }

  Future<Map<String, dynamic>> markUserNotificationAsRead(int id) async {
    return put('/user/notifications/$id/read', {});
  }

  // NEW: Support ticket endpoints
  Future<Map<String, dynamic>> getSupportTickets({
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    return get('/user/support/tickets', queryParams: queryParams);
  }

  Future<Map<String, dynamic>> createSupportTicket(
    Map<String, dynamic> body,
  ) async {
    return post('/user/support/tickets', body);
  }

  Future<Map<String, dynamic>> addMessageToTicket(
    int ticketId,
    Map<String, dynamic> body,
  ) async {
    return post('/user/support/tickets/$ticketId/messages', body);
  }

  // App settings (public endpoint)
  Future<Map<String, dynamic>> getAppSettings() async {
    return get(ApiConstants.appSettings);
  }
}
