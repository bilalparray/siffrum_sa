import 'package:dio/dio.dart';
import 'package:siffrum_sa/constants/environment.dart';

/// A centralized API client using Dio, returning ApiResponse for all calls.
class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrl,
      connectTimeout: const Duration(milliseconds: Environment.connectTimeout),
      receiveTimeout: const Duration(milliseconds: Environment.receiveTimeout),
      headers: Environment.headers,
    ),
  );

  /// Add global interceptors (e.g. auth token) before any requests.
  static void initializeInterceptors(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }
}
