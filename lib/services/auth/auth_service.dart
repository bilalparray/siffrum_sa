import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siffrum_sa/constants/environment.dart';
import 'package:siffrum_sa/models/error_data.dart';
import 'package:siffrum_sa/main.dart';
import 'package:siffrum_sa/navigation/navigarion.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  String? _refreshToken;

  /// Initialize by loading token & refresh token from storage.
  Future<void> init() async {
    _token = await _storage.read(key: _tokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);
  }

  /// Check login status
  bool get isLoggedIn => _token != null;

  /// Get current token
  String? get token => _token;

  /// Dio interceptor to add Authorization header
  Interceptor get dioInterceptor => InterceptorsWrapper(
    onRequest: (options, handler) async {
      if (_token != null) {
        options.headers['Authorization'] = 'Bearer $_token';
      }
      handler.next(options);
    },
    onError: (err, handler) async {
      if (err.response?.statusCode == 401) {
        await logout();
      }
      handler.next(err);
    },
  );

  /// Perform login and store token + refresh token
  Future<void> login({
    required String username,
    required String password,
    required String role,
  }) async {
    final dio = Dio();
    final fullUrl = Environment.baseUrl + Environment.apiEndPoints['login']!;
    final body = {
      'reqData': {'username': username, 'password': password, 'role': role},
    };

    try {
      final response = await dio.post(
        fullUrl,
        data: body,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (_) => true,
        ),
      );

      final Map<String, dynamic> data = response.data is String
          ? json.decode(response.data as String) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final successData = data['successData'];
        if (successData != null && successData is Map<String, dynamic>) {
          final token = successData['accessToken'] as String;
          final refreshToken = successData['refreshToken'] as String?;
          await _storage.write(key: _tokenKey, value: token);
          if (refreshToken != null) {
            await _storage.write(key: _refreshTokenKey, value: refreshToken);
          }
          _token = token;
          _refreshToken = refreshToken;
        } else {
          final message = data['message'] as String? ?? 'Invalid credentials';
          throw Exception(message);
        }
      } else {
        final apiError = ApiError.fromJson(data);
        throw Exception(
          apiError.errorData?.displayMessage ?? 'Unknown API error',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get the current token
  String? getToken() => _token;

  /// Refresh token logic
  Future<String?> refreshToken() async {
    if (_refreshToken == null) {
      return null;
    }

    final dio = Dio();
    final refreshUrl =
        Environment.baseUrl + Environment.apiEndPoints['refreshToken']!;

    try {
      final response = await dio.post(
        refreshUrl,
        data: {'refreshToken': _refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (_) => true,
        ),
      );

      final Map<String, dynamic> data = response.data is String
          ? json.decode(response.data as String) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final successData = data['successData'];
        if (successData != null && successData is Map<String, dynamic>) {
          final newToken = successData['accessToken'] as String;
          final newRefreshToken = successData['refreshToken'] as String?;
          await _storage.write(key: _tokenKey, value: newToken);
          if (newRefreshToken != null) {
            await _storage.write(key: _refreshTokenKey, value: newRefreshToken);
          }
          _token = newToken;
          _refreshToken = newRefreshToken;
          return newToken;
        }
      }

      await logout();
      return null;
    } on DioException catch (e) {
      await logout();
      return null;
    }
  }

  /// Clear token and logout
  Future<void> logout() async {
    _token = null;
    _refreshToken = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }
}
