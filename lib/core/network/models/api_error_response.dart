import 'package:equatable/equatable.dart';

/// Class parse Envelope Phản hồi Lỗi từ Django Backend:
/// {"success": false, "error": {"code": "...", "message": "...", "details": {...}}}
class ApiErrorResponse extends Equatable {
  final bool success;
  final String code;
  final String message;
  final dynamic details;

  const ApiErrorResponse({
    this.success = false,
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    final errorObj = json['error'] as Map<String, dynamic>? ?? {};
    return ApiErrorResponse(
      success: json['success'] as bool? ?? false,
      code: errorObj['code'] as String? ?? 'UNKNOWN_ERROR',
      message: errorObj['message'] as String? ?? 'Đã xảy ra lỗi không xác định.',
      details: errorObj['details'],
    );
  }

  @override
  List<Object?> get props => [success, code, message, details];
}
