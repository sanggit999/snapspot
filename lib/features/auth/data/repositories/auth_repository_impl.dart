import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/dio/dio_client.dart';
import 'package:snapspot/core/network/services/storage_service.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';
import 'package:snapspot/features/auth/data/mappers/user_mapper.dart';

/// Triển khai AuthRepositoryImpl tuân thủ nghiêm ngặt Clean Architecture 
/// & Flutter Code Quality Skill (Dùng Extension Mapper & fpdart Either).
class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final StorageService _storageService;

  AuthRepositoryImpl({
    DioClient? dioClient,
    StorageService? storageService,
  })  : _dioClient = dioClient ?? DioClient(DioClient as dynamic),
        _storageService = storageService ?? StorageService();

  @override
  Future<Either<Failure, UserEntity?>> checkAuthStatus() async {
    try {
      final token = await _storageService.getAccessToken();
      if (token == null || token.isEmpty) {
        return const Right(null);
      }

      // Gọi API GET /auth/me/ lấy thông tin User từ Backend
      final result = await _dioClient.get<UserModel>(
        '/auth/me/',
        fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      return result.map((userModel) => userModel.toEntity());
    } catch (e) {
      return Left(CacheFailure('Lỗi kiểm tra trạng thái đăng nhập: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String emailOrUsername,
    String password,
  ) async {
    final result = await _dioClient.post<Map<String, dynamic>>(
      '/auth/login/',
      data: {
        'email_or_username': emailOrUsername.trim(),
        'password': password,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return result.fold(
      (failure) => Left(failure),
      (dataMap) async {
        final accessToken = dataMap['access_token'] as String? ?? '';
        final refreshToken = dataMap['refresh_token'] as String? ?? '';
        final userJson = dataMap['user'] as Map<String, dynamic>? ?? {};

        final userModel = UserModel.fromJson(userJson);
        final userEntity = userModel.toEntity();

        // Lưu Access Token, Refresh Token & User ID vào Secure Storage
        await _storageService.saveAccessToken(accessToken);
        await _storageService.saveRefreshToken(refreshToken);
        await _storageService.saveUserInfo(
          userId: int.tryParse(userEntity.id) ?? 0,
          email: userEntity.email,
        );

        return Right(userEntity);
      },
    );
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String username,
    String email,
    String password,
  ) async {
    final result = await _dioClient.post<UserModel>(
      '/auth/register/',
      data: {
        'email': email.trim().toLowerCase(),
        'username': username.trim(),
        'password': password,
      },
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    return result.fold(
      (failure) => Left(failure),
      (userModel) async {
        // Tự động đăng nhập lại sau khi đăng ký thành công
        final loginResult = await login(email, password);
        return loginResult;
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _storageService.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Không thể xoá dữ liệu đăng xuất: $e'));
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
    final result = await _dioClient.put<UserModel>(
      '/auth/me/',
      data: {
        'full_name': fullName.trim(),
        'username': username.trim(),
        'bio': bio.trim(),
        'is_private': isPrivate,
      },
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    return result.map((userModel) => userModel.toEntity());
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final result = await _dioClient.post<Map<String, dynamic>>(
      '/auth/change-password/',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }
}
