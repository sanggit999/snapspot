import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/buttons/app_button.dart';
import 'package:snapspot/core/widgets/inputs/app_text_field.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';

/// Màn hình đăng ký tài khoản mới của SnapSpot chuẩn Type Scale & High Contrast Light/Dark Mode.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
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
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('register'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17.5,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go('/');
            } else if (state is AuthFailure) {
              setState(() {
                _errorMessage = state.message;
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.tr('create_account'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24.0,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đăng ký để khám phá các địa điểm check-in hấp dẫn',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isLight
                          ? AppColors.textLightSecondary
                          : AppColors.textDarkSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Banner báo lỗi
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.redAccent, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Họ & Tên
                  AppTextField(
                    controller: _fullNameController,
                    hintText: context.tr('full_name'),
                    labelText: context.tr('full_name'),
                    prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('full_name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

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
                  BlocSelector<AuthCubit, AuthState, bool>(
                    selector: (state) => state is AuthLoading,
                    builder: (context, isLoading) {
                      return AppButton(
                        label: context.tr('register'),
                        isLoading: isLoading,
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
                            fontSize: 14.0,
                            color: isLight
                                ? AppColors.textLightSecondary
                                : AppColors.textDarkSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
