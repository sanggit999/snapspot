import 'package:equatable/equatable.dart';

/// Class ngoại lệ đại diện cho tất cả các lỗi xảy ra ở Tầng Mạng Network
class NetworkException extends Equatable implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic details;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  @override
  List<Object?> get props => [message, statusCode, errorCode, details];

  @override
  String toString() => 'NetworkException($statusCode, $errorCode): $message';
}

/// Không có kết nối Internet
class NoInternetException extends NetworkException {
  const NoInternetException({super.message = 'Không có kết nối Internet. Vui lòng kiểm tra lại Wi-Fi hoặc 4G.'});
}

/// Request bị Timeout
class TimeoutException extends NetworkException {
  const TimeoutException({super.message = 'Kết nối mạng quá thời hạn. Vui lòng thử lại.'});
}

/// Lỗi 401 Unauthorized / Token hết hạn
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    super.message = 'Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.',
    super.statusCode = 401,
    super.errorCode = 'UNAUTHORIZED',
    super.details,
  });
}

/// Lỗi 403 Forbidden
class ForbiddenException extends NetworkException {
  const ForbiddenException({
    super.message = 'Bạn không có quyền thực hiện thao tác này.',
    super.statusCode = 403,
    super.errorCode = 'FORBIDDEN',
    super.details,
  });
}

/// Lỗi 404 Not Found
class NotFoundException extends NetworkException {
  const NotFoundException({
    super.message = 'Không tìm thấy dữ liệu yêu cầu.',
    super.statusCode = 404,
    super.errorCode = 'NOT_FOUND',
    super.details,
  });
}

/// Lỗi 500+ Internal Server Error
class ServerInternalException extends NetworkException {
  const ServerInternalException({
    super.message = 'Máy chủ đang gặp sự cố. Vui lòng thử lại sau ít phút.',
    super.statusCode = 500,
    super.errorCode = 'SERVER_ERROR',
    super.details,
  });
}
