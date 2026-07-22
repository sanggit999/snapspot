import 'package:equatable/equatable.dart';

/// Lớp cơ sở định nghĩa các lỗi (Failures) trong hệ thống theo Clean Architecture.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => message;
}

/// Lỗi xảy ra từ phía Server Backend (REST API / 500 / 400)
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

/// Lỗi xảy ra do không có kết nối Internet hoặc Timeout
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.statusCode});
}

/// Lỗi liên quan đến Xác thực (401 Unauthorized / Sai mật khẩu / Token hết hạn)
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.statusCode});
}

/// Lỗi Không có quyền truy cập (403 Forbidden)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.statusCode});
}

/// Lỗi xảy ra khi truy cập bộ nhớ cache cục bộ (Hive / Secure Storage)
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.statusCode});
}

/// Lỗi Dữ liệu nhập vào không hợp lệ (Validation Form)
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure(super.message, {this.errors, super.statusCode});

  @override
  List<Object?> get props => [message, statusCode, errors];
}
