import 'package:dio/dio.dart';
import 'package:siffrum_sa/constants/environment.dart';
import '../models/api_response.dart';
import '../models/error_data.dart';

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

  /// Generic GET
  static Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final data = decoder != null
          ? decoder(response.data)
          : response.data as T;
      return ApiResponse<T>(
        successData: data,
        statusCode: response.statusCode ?? 0,
      );
    } on DioException catch (err) {
      return _handleDioError<T>(err);
    } catch (e) {
      return ApiResponse<T>(
        statusCode: -1,
        isError: true,
        errorData: ErrorData(displayMessage: e.toString()),
      );
    }
  }

  /// Generic POST
  static Future<ApiResponse<R>> post<P, R>(
    String path, {
    required P data,
    R Function(dynamic json)? decoder,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      final result = decoder != null
          ? decoder(response.data)
          : response.data as R;
      return ApiResponse<R>(
        successData: result,
        statusCode: response.statusCode ?? 0,
      );
    } on DioException catch (err) {
      return _handleDioError<R>(err);
    } catch (e) {
      return ApiResponse<R>(
        statusCode: -1,
        isError: true,
        errorData: ErrorData(displayMessage: e.toString()),
      );
    }
  }

  /// Generic PUT
  static Future<ApiResponse<R>> put<P, R>(
    String path, {
    required P data,
    R Function(dynamic json)? decoder,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      final result = decoder != null
          ? decoder(response.data)
          : response.data as R;
      return ApiResponse<R>(
        successData: result,
        statusCode: response.statusCode ?? 0,
      );
    } on DioException catch (err) {
      return _handleDioError<R>(err);
    } catch (e) {
      return ApiResponse<R>(
        statusCode: -1,
        isError: true,
        errorData: ErrorData(displayMessage: e.toString()),
      );
    }
  }

  /// Generic DELETE
  static Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      final data = decoder != null
          ? decoder(response.data)
          : response.data as T;
      return ApiResponse<T>(
        successData: data,
        statusCode: response.statusCode ?? 0,
      );
    } on DioException catch (err) {
      return _handleDioError<T>(err);
    } catch (e) {
      return ApiResponse<T>(
        statusCode: -1,
        isError: true,
        errorData: ErrorData(displayMessage: e.toString()),
      );
    }
  }

  /// Centralized DioError handler converting to ApiResponse with ErrorData
  static ApiResponse<T> _handleDioError<T>(DioException err) {
    final status = err.response?.statusCode ?? -1;
    ErrorData error;
    if (err.response?.data is Map<String, dynamic>) {
      error = ErrorData.fromJson(err.response!.data as Map<String, dynamic>);
    } else {
      error = ErrorData(displayMessage: err.message);
    }
    return ApiResponse<T>(statusCode: status, isError: true, errorData: error);
  }
}
