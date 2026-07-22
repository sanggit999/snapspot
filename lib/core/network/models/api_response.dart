import 'package:equatable/equatable.dart';

/// Class parse Envelope Phản hồi Thành công từ Django Backend:
/// {"success": true, "data": ...}
class ApiResponse<T> extends Equatable {
  final bool success;
  final T data;

  const ApiResponse({
    required this.success,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      data: fromJsonT(json['data']),
    );
  }

  @override
  List<Object?> get props => [success, data];
}
