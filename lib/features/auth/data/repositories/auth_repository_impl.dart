import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/core/security/secure_storage_service.dart';
import 'package:snapspot/features/auth/data/mappers/user_mapper.dart';
import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

/// Triển khai AuthRepositoryImpl sử dụng fpdart Either, Freezed UserModel, UserMapper
/// và SecureStorageService (Android Keystore / iOS Keychain) tuân thủ tiêu chuẩn bảo mật.
class AuthRepositoryImpl implements AuthRepository {
  static const String _boxName = 'settingsBox';
  static const String _tokenKey = 'accessToken';
  static const String _userIdKey = 'loggedInUserId';

  @override
  Future<Either<Failure, UserEntity?>> checkAuthStatus() async {
    try {
      // Đọc thông tin xác thực an toàn từ Secure Storage (Android Keystore / iOS Keychain)
      String? token = await SecureStorageService.getAccessToken();
      String? savedUserId = await SecureStorageService.getUserId();

      // Hỗ trợ fallback kiểm tra từ Hive cũ (nếu chuyển đổi phiên bản)
      if ((token == null || savedUserId == null) && Hive.isBoxOpen(_boxName)) {
        final box = Hive.box(_boxName);
        token ??= box.get(_tokenKey) as String?;
        savedUserId ??= box.get(_userIdKey) as String?;
      }

      if (token != null && savedUserId != null) {
        final matchedUser = MockData.mockUsers.firstWhere(
          (u) => u.id == savedUserId,
          orElse: () => MockData.mockUsers[0],
        );
        return Right(matchedUser);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Lỗi kiểm tra trạng thái xác thực an toàn: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      final user = MockData.mockUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
        orElse: () => throw Exception('Email hoặc mật khẩu không chính xác'),
      );

      if (password.length < 6) {
        throw Exception('Mật khẩu phải từ 6 ký tự trở lên');
      }

      // Lưu trữ Access Token và User ID vào Secure Storage mã hóa phần cứng
      final token = 'mock_jwt_token_for_${user.id}';
      await SecureStorageService.saveAccessToken(token);
      await SecureStorageService.saveUserId(user.id);

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      final isEmailTaken = MockData.mockUsers.any(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      );
      if (isEmailTaken) {
        throw Exception('Email này đã được sử dụng');
      }

      final isUsernameTaken = MockData.mockUsers.any(
        (u) => u.username.toLowerCase() == username.trim().toLowerCase(),
      );
      if (isUsernameTaken) {
        throw Exception('Tên người dùng đã tồn tại');
      }

      final newUserModel = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        username: username,
        fullName: username,
        avatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        bio: 'Chào mừng tôi đến với SnapSpot!',
        isPrivate: false,
        postsCount: 0,
        followersCount: 0,
        followingCount: 0,
      );

      final newUserEntity = UserMapper.toEntity(newUserModel);
      MockData.mockUsers.add(newUserEntity);

      // Lưu trữ Access Token và User ID vào Secure Storage
      final token = 'mock_jwt_token_for_${newUserEntity.id}';
      await SecureStorageService.saveAccessToken(token);
      await SecureStorageService.saveUserId(newUserEntity.id);

      return Right(newUserEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Tiêu hủy sạch sẽ toàn bộ Token & thông tin xác thực ở Secure Storage
      await SecureStorageService.clearAll();

      if (Hive.isBoxOpen(_boxName)) {
        final box = Hive.box(_boxName);
        await box.delete(_tokenKey);
        await box.delete(_userIdKey);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Không thể xoá cache đăng xuất: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    required String fullName,
    required String username,
    required String bio,
    required bool isPrivate,
    String? avatarUrl,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000)); // Giả lập độ trễ lưu mạng

      final idx = MockData.mockUsers.indexWhere((u) => u.id == userId);
      if (idx != -1) {
        final existingUser = MockData.mockUsers[idx];
        final updatedUser = existingUser.copyWith(
          fullName: fullName.trim(),
          username: username.trim().toLowerCase(),
          bio: bio.trim(),
          isPrivate: isPrivate,
          avatarUrl: avatarUrl ?? existingUser.avatarUrl,
        );

        // Cập nhật lại trong MockData
        MockData.mockUsers[idx] = updatedUser;

        // Cập nhật lại tất cả bài viết của User này trong MockData.mockPosts
        for (int i = 0; i < MockData.mockPosts.length; i++) {
          if (MockData.mockPosts[i].user.id == userId) {
            MockData.mockPosts[i] = MockData.mockPosts[i].copyWith(
              user: updatedUser,
            );
          }
        }

        return Right(updatedUser);
      }
      throw Exception('Người dùng không tồn tại');
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000)); // Giả lập mạng

      // Giả lập mật khẩu mặc định của mọi user là 123456
      if (oldPassword != '123456') {
        throw Exception('Mật khẩu hiện tại không chính xác');
      }

      if (newPassword.length < 6) {
        throw Exception('Mật khẩu mới phải từ 6 ký tự trở lên');
      }

      if (oldPassword == newPassword) {
        throw Exception('Mật khẩu mới không được trùng mật khẩu cũ');
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
