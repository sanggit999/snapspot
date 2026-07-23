import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/core/usecase/usecase.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {
  final String emailOrUsername;
  final String password;

  const LoginParams({
    required this.emailOrUsername,
    required this.password,
  });

  @override
  List<Object?> get props => [emailOrUsername, password];
}

/// UseCase thực hiện nghiệp vụ Đăng nhập người dùng
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(params.emailOrUsername, params.password);
  }
}
