import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/core/usecase/usecase.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

/// UseCase thực hiện nghiệp vụ Đăng ký tài khoản người dùng mới
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(params.username, params.email, params.password);
  }
}
