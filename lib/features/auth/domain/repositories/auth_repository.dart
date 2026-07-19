import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Giao diện AuthRepository sử dụng lập trình hàm với fpdart Either.
abstract class AuthRepository {
  /// Kiểm tra trạng thái đăng nhập hiện tại từ bộ nhớ cục bộ
  Future<Either<Failure, UserEntity?>> checkAuthStatus();

  /// Đăng nhập bằng Email và Mật khẩu
  Future<Either<Failure, UserEntity>> login(String email, String password);

  /// Đăng ký tài khoản người dùng mới
  Future<Either<Failure, UserEntity>> register(
    String username,
    String email,
    String password,
  );

  /// Đăng xuất khỏi hệ thống
  Future<Either<Failure, void>> logout();

  /// Cập nhật thông tin cá nhân của người dùng
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    required String fullName,
    required String username,
    required String bio,
    required bool isPrivate,
    String? avatarUrl,
  });

  /// Thay đổi mật khẩu người dùng
  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });
}
