import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/core/usecase/usecase.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

/// UseCase kiểm tra trạng thái phiên đăng nhập của người dùng
class CheckAuthStatusUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.checkAuthStatus();
  }
}
