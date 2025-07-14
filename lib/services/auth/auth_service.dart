import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siffrum_sa/constants/environment.dart';

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
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final successData = response.data['successData'];
        if (successData != null) {
          _token = successData['accessToken'] as String;
          await _storage.write(key: _tokenKey, value: _token);
        } else {
          final message = response.data['message'] ?? 'Invalid credentials';
          throw Exception(message);
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Clear token and logout
  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
  }
}
