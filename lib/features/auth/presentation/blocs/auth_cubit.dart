import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/core/usecase/usecase.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';
import 'package:snapspot/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/login_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/register_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/logout_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/change_password_usecase.dart';

// --- STATES ---
abstract class AuthState {
  const AuthState();

  bool get isLoggedIn => this is AuthSuccess;
  UserEntity? get user =>
      this is AuthSuccess ? (this as AuthSuccess).currentUser : null;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserEntity currentUser;
  const AuthSuccess(this.currentUser);
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

// --- CUBIT ---
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  }) : super(const AuthInitial()) {
    checkAuthStatus();
  }

  /// Constructor phụ hỗ trợ khởi tạo trực tiếp từ AuthRepository nếu cần
  factory AuthCubit.fromRepository(AuthRepository repository) {
    return AuthCubit(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
      checkAuthStatusUseCase: CheckAuthStatusUseCase(repository),
      logoutUseCase: LogoutUseCase(repository),
      updateProfileUseCase: UpdateProfileUseCase(repository),
      changePasswordUseCase: ChangePasswordUseCase(repository),
    );
  }

  /// Kiểm tra xem người dùng đã đăng nhập trước đó chưa
  void checkAuthStatus() async {
    final result = await checkAuthStatusUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthInitial()),
      (user) {
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(const AuthInitial());
        }
      },
    );
  }

  /// Xử lý đăng nhập bằng email/username và mật khẩu
  Future<void> login(String emailOrUsername, String password) async {
    emit(const AuthLoading());
    final result = await loginUseCase(
      LoginParams(emailOrUsername: emailOrUsername, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  /// Xử lý đăng ký tài khoản mới
  Future<void> register(String username, String email, String password) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      RegisterParams(username: username, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  /// Đăng xuất khỏi hệ thống
  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthInitial()),
      (_) => emit(const AuthInitial()),
    );
  }

  /// Cập nhật thông tin cá nhân của người dùng đang đăng nhập
  Future<bool> updateUserProfile({
    required String fullName,
    required String username,
    required String bio,
    required bool isPrivate,
    String? avatarUrl,
  }) async {
    final currentState = state;
    if (currentState is AuthSuccess) {
      final result = await updateProfileUseCase(
        UpdateProfileParams(
          userId: currentState.currentUser.id,
          fullName: fullName,
          username: username,
          bio: bio,
          isPrivate: isPrivate,
          avatarUrl: avatarUrl,
        ),
      );

      return result.fold(
        (failure) => false,
        (updatedUser) {
          emit(AuthSuccess(updatedUser));
          return true;
        },
      );
    }
    return false;
  }

  /// Đổi mật khẩu của người dùng đang đăng nhập
  Future<String?> changeUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final currentState = state;
    if (currentState is AuthSuccess) {
      final result = await changePasswordUseCase(
        ChangePasswordParams(
          userId: currentState.currentUser.id,
          oldPassword: oldPassword,
          newPassword: newPassword,
        ),
      );

      return result.fold(
        (failure) => failure.message,
        (_) => null,
      );
    }
    return 'Bạn chưa đăng nhập';
  }
}
