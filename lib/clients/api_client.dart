import 'package:dio/dio.dart';
import 'package:siffrum_sa/constants/environment.dart';
import 'package:siffrum_sa/services/auth/auth_service.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrl,
      connectTimeout: Duration(milliseconds: Environment.connectTimeout),
      receiveTimeout: Duration(milliseconds: Environment.receiveTimeout),
      headers: Environment.headers,
    ),
  );

  static Dio get client => _dio;

  /// Initialize Dio with Auth Interceptor (Call this at app startup)
  static void initialize() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = AuthService.instance.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (err, handler) async {
          final statusCode = err.response?.statusCode;
          if (statusCode == 401) {
            final newToken = await AuthService.instance.refreshToken();

            if (newToken != null) {
              final clonedRequest = err.requestOptions;
              clonedRequest.headers['Authorization'] = 'Bearer $newToken';
              try {
                final retryResponse = await _dio.fetch(clonedRequest);
                return handler.resolve(retryResponse);
              } catch (e) {
                await AuthService.instance.logout();
                return handler.next(err);
              }
            } else {
              await AuthService.instance.logout();
              return handler.next(err);
            }
          } else if (statusCode == 403) {
            // Optional: Show a toast/snackbar or redirect
            return handler.next(err);
          } else {
            return handler.next(err);
          }
        },
      ),
    );
  }
}
