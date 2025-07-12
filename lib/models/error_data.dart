class ErrorData {
  final String? displayMessage;
  final int? code;
  final Map<String, dynamic>? raw;

  ErrorData({this.displayMessage, this.code, this.raw});

  factory ErrorData.fromJson(Map<String, dynamic> json) {
    return ErrorData(
      raw: json,
      displayMessage: json['message'] as String?,
      code: json['code'] as int?,
    );
  }

  /// Convert back to JSON (e.g. for logging).
  Map<String, dynamic> toJson() {
    return {
      if (displayMessage != null) 'message': displayMessage,
      if (code != null) 'code': code,
    };
  }

  /// A non‑nullable message you can safely show in your UI:
  /// - If displayMessage is present and non‑empty, returns that.
  /// - Otherwise falls back to a generic text.
  String get userMessage {
    final msg = displayMessage?.trim();
    if (msg != null && msg.isNotEmpty) return msg;
    return 'Something went wrong. Please try again.';
  }
}
