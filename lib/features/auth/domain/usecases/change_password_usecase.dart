import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/core/usecase/usecase.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordParams extends Equatable {
  final String userId;
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, oldPassword, newPassword];
}

/// UseCase thực hiện nghiệp vụ Thay đổi mật khẩu người dùng
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return repository.changePassword(
      userId: params.userId,
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}
