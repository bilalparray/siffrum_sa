// lib/models/api_error.dart

class ApiError {
  final int responseStatusCode;
  final bool isError;
  final ErrorData? errorData;

  ApiError({
    required this.responseStatusCode,
    required this.isError,
    this.errorData,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      responseStatusCode: json['responseStatusCode'] as int,
      isError: json['isError'] as bool,
      errorData: json['errorData'] != null
          ? ErrorData.fromJson(json['errorData'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ErrorData {
  final String displayMessage;
  final int apiErrorType;

  ErrorData({required this.displayMessage, required this.apiErrorType});

  factory ErrorData.fromJson(Map<String, dynamic> json) {
    return ErrorData(
      displayMessage: json['displayMessage'] as String,
      apiErrorType: json['apiErrorType'] as int,
    );
  }
}
