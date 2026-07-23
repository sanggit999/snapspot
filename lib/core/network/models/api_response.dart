import 'package:equatable/equatable.dart';

/// Class parse Phản hồi từ Django Backend:
/// Hỗ trợ cả 2 chuẩn response:
/// 1. Envelope format: {"success": true, "data": {...}}
/// 2. Flat format: {"access_token": "...", "user": {...}}
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
    // Tự động kiểm tra xem Django trả về dạng Envelope `data` hay dạng phẳng Flat object
    final hasDataKey = json.containsKey('data') && json['data'] != null;
    final payload = hasDataKey ? json['data'] : json;

    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      data: fromJsonT(payload),
    );
  }

  @override
  List<Object?> get props => [success, data];
}
