import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';

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
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial()) {
    checkAuthStatus();
  }

  /// Kiểm tra xem người dùng đã đăng nhập trước đó chưa
  void checkAuthStatus() async {
    final result = await _authRepository.checkAuthStatus();
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

  /// Xử lý đăng nhập bằng email và mật khẩu
  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    final result = await _authRepository.login(email, password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  /// Xử lý đăng ký tài khoản mới
  Future<void> register(String username, String email, String password) async {
    emit(const AuthLoading());
    final result = await _authRepository.register(username, email, password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  /// Đăng xuất khỏi hệ thống
  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await _authRepository.logout();
    result.fold(
      (failure) => emit(const AuthInitial()),
      (_) => emit(const AuthInitial()),
    );
  }
}
