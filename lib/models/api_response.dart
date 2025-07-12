class ApiResponse<T> {
  final T? successData;
  final int statusCode;
  final bool isError;
  final dynamic errorData;
  ApiResponse({
    this.successData,
    required this.statusCode,
    this.isError = false,
    this.errorData,
  });
}
