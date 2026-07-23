import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/core/usecase/usecase.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileParams extends Equatable {
  final String userId;
  final String fullName;
  final String username;
  final String bio;
  final bool isPrivate;
  final String? avatarUrl;

  const UpdateProfileParams({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.isPrivate,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [userId, fullName, username, bio, isPrivate, avatarUrl];
}

/// UseCase thực hiện nghiệp vụ Cập nhật thông tin profile người dùng
class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      userId: params.userId,
      fullName: params.fullName,
      username: params.username,
      bio: params.bio,
      isPrivate: params.isPrivate,
      avatarUrl: params.avatarUrl,
    );
  }
}
