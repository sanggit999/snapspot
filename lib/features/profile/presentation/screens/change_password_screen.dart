import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';

/// Màn hình Đổi mật khẩu (Change Password Screen) chuẩn Type Scale & High-Contrast Light/Dark Mode.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final errorMsg = await context.read<AuthCubit>().changeUserPassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        );

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      if (errorMsg == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('success')),
            backgroundColor: AppColors.primary,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('change_password'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17.5,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // 1. Ô nhập Mật khẩu hiện tại
                  _buildLabel(context, context.tr('current_password_label')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: _obscureOld,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                    ),
                    decoration: _buildInputDecoration(
                      context: context,
                      hint: context.tr('current_password_hint'),
                      obscure: _obscureOld,
                      onToggleObscure: () {
                        setState(() {
                          _obscureOld = !_obscureOld;
                        });
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return context.tr('current_password_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 2. Ô nhập Mật khẩu mới
                  _buildLabel(context, context.tr('new_password_label')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                    ),
                    decoration: _buildInputDecoration(
                      context: context,
                      hint: context.tr('new_password_hint'),
                      obscure: _obscureNew,
                      onToggleObscure: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return context.tr('new_password_required');
                      }
                      if (val.length < 6) {
                        return context.tr('password_too_short');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 3. Ô nhập lại Mật khẩu mới
                  _buildLabel(context, context.tr('confirm_new_password_label')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                    ),
                    decoration: _buildInputDecoration(
                      context: context,
                      hint: context.tr('confirm_new_password_hint'),
                      obscure: _obscureConfirm,
                      onToggleObscure: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return context.tr('confirm_new_password_required');
                      }
                      if (val != _newPasswordController.text) {
                        return context.tr('passwords_do_not_match');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // 4. Nút Cập Nhật Mật Khẩu
                  ElevatedButton(
                    onPressed: _isSaving ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            context.tr('update_password'),
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hint,
    required bool obscure,
    required VoidCallback onToggleObscure,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
        fontSize: 14.0,
      ),
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
        ),
        onPressed: onToggleObscure,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
