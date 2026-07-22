import 'package:equatable/equatable.dart';

/// Lớp cơ sở định nghĩa các phản hồi Thành công (Successes) trong hệ thống theo Clean Architecture.
abstract class Success<T> extends Equatable {
  final String message;
  final T? data;

  const Success(this.message, {this.data});

  @override
  List<Object?> get props => [message, data];

  @override
  String toString() => message;
}

/// Thành công từ phản hồi của Server Backend API
class ServerSuccess<T> extends Success<T> {
  const ServerSuccess(super.message, {super.data});
}

/// Thành công khi truy cập/lưu trữ Bộ nhớ Cục bộ (Hive / Secure Storage)
class CacheSuccess<T> extends Success<T> {
  const CacheSuccess(super.message, {super.data});
}

/// Thành công trong các thao tác Xác thực (Đăng nhập, Đăng ký, Đổi mật khẩu)
class AuthSuccess<T> extends Success<T> {
  const AuthSuccess(super.message, {super.data});
}
