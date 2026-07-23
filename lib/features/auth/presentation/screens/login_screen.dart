import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/buttons/app_button.dart';
import 'package:snapspot/core/widgets/inputs/app_text_field.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';

/// Màn hình Đăng nhập SnapSpot hỗ trợ Email HOẶC Username chuẩn Light/Dark Mode.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(
    text: 'admin@snapspot.com',
  );
  final _passwordController = TextEditingController(text: 'AdminPassword123!');
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // 1. Logo & Brand Name
                  Center(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera_back_rounded,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  Column(
                    spacing: 4.0,
                    children: [
                      Center(
                        child: Text(
                          'SnapSpot',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 32.0,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          context.tr('app_slogan'),
                          style: TextStyle(
                            color: isLight
                                ? AppColors.textLightSecondary
                                : AppColors.textDarkSecondary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2. Banner Thông báo Lỗi Đăng nhập (nếu có)
                  if (_errorMessage != null)
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

                  // 3. Email HOẶC Username Input
                  AppTextField(
                    controller: _emailController,
                    hintText: context.tr('enter_email_or_username'),
                    labelText: context.tr('email_or_username'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('email_or_username_required');
                      }
                      return null;
                    },
                  ),

                  // 4. Password Input
                  AppTextField(
                    controller: _passwordController,
                    hintText: context.tr('enter_password'),
                    labelText: context.tr('password'),
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onLoginPressed(),
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

                  // 5. Quên mật khẩu
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        context.tr('forgot_password'),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),

                  // 6. Nút Đăng nhập
                  BlocSelector<AuthCubit, AuthState, bool>(
                    selector: (state) => state is AuthLoading,
                    builder: (context, isLoading) {
                      return AppButton(
                        label: context.tr('login'),
                        isLoading: isLoading,
                        onPressed: _onLoginPressed,
                      );
                    },
                  ),

                  // 7. Hoặc đăng nhập bằng MXH
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          context.tr('or_continue_with'),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: isLight
                                ? AppColors.textLightSecondary
                                : AppColors.textDarkSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  // Social login buttons
                  Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthCubit>().login(
                                  'admin@snapspot.com',
                                  'AdminPassword123!',
                                );
                          },
                          icon: const Icon(Icons.g_mobiledata, size: 28),
                          label: const Text(
                            'Google',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                            side: BorderSide(
                              color: isLight ? AppColors.borderLight : AppColors.borderDark,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthCubit>().login(
                                  'admin',
                                  'AdminPassword123!',
                                );
                          },
                          icon: const Icon(Icons.apple, size: 22),
                          label: const Text(
                            'Apple',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                            side: BorderSide(
                              color: isLight ? AppColors.borderLight : AppColors.borderDark,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 8. Chuyển sang Đăng ký
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr('dont_have_account'),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: isLight
                              ? AppColors.textLightSecondary
                              : AppColors.textDarkSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/register');
                        },
                        child: Text(
                          context.tr('register'),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
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
