// lib/core/services/api_client.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth endpoints
  @POST(ApiConstants.login)
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.register)
  Future<Map<String, dynamic>> register(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.verifyEmail)
  Future<Map<String, dynamic>> verifyEmail(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.forgotPassword)
  Future<Map<String, dynamic>> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  // User endpoints
  @GET(ApiConstants.profile)
  Future<Map<String, dynamic>> getProfile();

  @PUT(ApiConstants.updateProfile)
  Future<Map<String, dynamic>> updateProfile(@Body() Map<String, dynamic> body);

  @PUT(ApiConstants.changePassword)
  Future<Map<String, dynamic>> changePassword(
    @Body() Map<String, dynamic> body,
  );

  // Plan endpoints
  @GET(ApiConstants.plans)
  Future<Map<String, dynamic>> getPlans();

  @POST(ApiConstants.purchasePlan)
  Future<Map<String, dynamic>> purchasePlan(@Path() int id);

  // Deposit endpoints
  @POST(ApiConstants.depositCoingate)
  Future<Map<String, dynamic>> depositViaCoingate(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.depositUddoktapay)
  Future<Map<String, dynamic>> depositViaUddoktapay(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.depositManual)
  Future<Map<String, dynamic>> depositViaManual(
    @Body() Map<String, dynamic> body,
  );

  // Withdrawal endpoints
  @GET(ApiConstants.withdrawals)
  Future<Map<String, dynamic>> getWithdrawals();

  @POST(ApiConstants.withdrawals)
  Future<Map<String, dynamic>> requestWithdrawal(
    @Body() Map<String, dynamic> body,
  );

  // Transaction endpoints
  @GET(ApiConstants.transactions)
  Future<Map<String, dynamic>> getTransactions();

  // Task endpoints
  @GET(ApiConstants.tasks)
  Future<Map<String, dynamic>> getTasks();

  @POST('${ApiConstants.completeTask}')
  Future<Map<String, dynamic>> completeTask(@Path() int id);

  // Referral endpoints
  @GET(ApiConstants.referrals)
  Future<Map<String, dynamic>> getReferrals();

  @GET(ApiConstants.referralEarnings)
  Future<Map<String, dynamic>> getReferralEarnings();

  // KYC endpoints
  @POST(ApiConstants.kycSubmit)
  Future<Map<String, dynamic>> submitKyc(@Body() Map<String, dynamic> body);

  @GET(ApiConstants.kycStatus)
  Future<Map<String, dynamic>> getKycStatus();

  // Notification endpoints
  @GET(ApiConstants.notifications)
  Future<Map<String, dynamic>> getNotifications();

  @GET(ApiConstants.unreadNotifications)
  Future<Map<String, dynamic>> getUnreadNotificationsCount();

  @PUT('${ApiConstants.markNotificationRead}')
  Future<Map<String, dynamic>> markNotificationAsRead(@Path() int id);

  @PUT(ApiConstants.markAllNotificationsRead)
  Future<Map<String, dynamic>> markAllNotificationsAsRead();
}
