class ApiResponse<T> {
  final T? sucessData;
  final int statusCode;
  final bool isError;
  final dynamic errorData;
  ApiResponse({
    this.sucessData,
    required this.statusCode,
    this.isError = false,
    this.errorData,
  });
}
