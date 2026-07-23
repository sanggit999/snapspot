import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/core/usecase/usecase.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

/// UseCase thực hiện nghiệp vụ Đăng xuất khỏi hệ thống
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
