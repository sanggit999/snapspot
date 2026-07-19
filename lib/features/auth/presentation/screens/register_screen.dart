import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/app_button.dart';
import 'package:snapspot/core/widgets/app_text_field.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';

/// Màn hình đăng ký tài khoản của SnapSpot.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: theme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Đăng ký xong tự động đăng nhập và vào trang chủ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('check_email_to_verify')),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/');
          } else if (state is AuthFailure) {
            setState(() {
              _errorMessage = state.message;
            });
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Hero(
                    tag: 'logo',
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera_back_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      context.tr('register'),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Lỗi đăng ký
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Username
                  AppTextField(
                    controller: _usernameController,
                    hintText: context.tr('username'),
                    labelText: context.tr('username'),
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('username_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  AppTextField(
                    controller: _emailController,
                    hintText: context.tr('enter_email'),
                    labelText: context.tr('email'),
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('email_required');
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value.trim())) {
                        return context.tr('email_invalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mật khẩu
                  AppTextField(
                    controller: _passwordController,
                    hintText: context.tr('enter_password'),
                    labelText: context.tr('password'),
                    prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('password_required');
                      }
                      if (value.length < 6) {
                        return context.tr('password_too_short');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Xác nhận mật khẩu
                  AppTextField(
                    controller: _confirmPasswordController,
                    hintText: context.tr('confirm_password'),
                    labelText: context.tr('confirm_password'),
                    prefixIcon: const Icon(Icons.lock_reset_outlined, size: 20),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onRegisterPressed(),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return context.tr('passwords_do_not_match');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Nút đăng ký
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        label: context.tr('register'),
                        isLoading: state is AuthLoading,
                        onPressed: _onRegisterPressed,
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Có tài khoản rồi -> chuyển Đăng nhập
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          context.tr('have_account'),
                          style: TextStyle(
                            color: theme.brightness == Brightness.light
                                ? AppColors.textLightSecondary
                                : AppColors.textDarkSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
