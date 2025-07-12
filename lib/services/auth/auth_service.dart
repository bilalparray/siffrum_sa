import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;

  /// Initialize by loading token from storage.
  Future<void> init() async {
    _token = await _storage.read(key: _tokenKey);
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
          // Optional: handle token expiry (401)
          if (err.response?.statusCode == 401) {
            await logout();
          }
          handler.next(err);
        },
      );

  /// Perform login and store token
  Future<void> login({
    required String username,
    required String password,
  }) async {
    // Replace with your actual login endpoint
    final dio = Dio();
    final response = await dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    if (response.statusCode == 200 && response.data['token'] != null) {
      _token = response.data['token'] as String;
      await _storage.write(key: _tokenKey, value: _token);
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  /// Clear token and logout
  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
  }
}
