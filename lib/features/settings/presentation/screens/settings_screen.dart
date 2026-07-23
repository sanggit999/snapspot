import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/localization/language_cubit.dart';
import 'package:snapspot/core/theme/theme_cubit.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:snapspot/features/settings/presentation/widgets/settings_selectable_button.dart';
import 'package:snapspot/features/settings/presentation/widgets/settings_user_profile_tile.dart';

/// Màn hình Cài đặt (Settings Screen) chuẩn Type Scale & High Contrast Light/Dark Mode.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            context.tr('logout'),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          content: Text(
            context.tr('logout_confirm'),
            style: const TextStyle(fontSize: 14.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr('cancel'),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                context.read<AuthCubit>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(context.tr('logout'), style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.tr('settings'),
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
        body: BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, currentThemeMode) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, currentLocale) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Khung Profile Tóm tắt
                        if (authState is AuthSuccess) ...[
                          SettingsUserProfileTile(user: authState.currentUser),
                          const SizedBox(height: 24),
                        ],

                        // 2. Section: Thiết lập ứng dụng
                        _buildSectionTitle(context, context.tr('section_app_settings')),
                        const SizedBox(height: 12),

                        // Hộp chọn Ngôn ngữ
                        _buildSettingItem(
                          context: context,
                          title: context.tr('language'),
                          child: Row(
                            children: [
                              Expanded(
                                child: SettingsSelectableButton(
                                  label: 'Tiếng Việt',
                                  isSelected: currentLocale.languageCode == 'vi',
                                  onTap: () {
                                    context.read<LanguageCubit>().setLanguage('vi');
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SettingsSelectableButton(
                                  label: 'English',
                                  isSelected: currentLocale.languageCode == 'en',
                                  onTap: () {
                                    context.read<LanguageCubit>().setLanguage('en');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Hộp chọn Giao diện
                        _buildSettingItem(
                          context: context,
                          title: context.tr('theme_mode'),
                          child: Row(
                            children: [
                              Expanded(
                                child: SettingsSelectableButton(
                                  label: context.tr('light_theme'),
                                  isSelected: currentThemeMode == AppThemeMode.light,
                                  onTap: () {
                                    context
                                        .read<ThemeCubit>()
                                        .setThemeMode(AppThemeMode.light);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SettingsSelectableButton(
                                  label: context.tr('dark_theme'),
                                  isSelected: currentThemeMode == AppThemeMode.dark,
                                  onTap: () {
                                    context
                                        .read<ThemeCubit>()
                                        .setThemeMode(AppThemeMode.dark);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SettingsSelectableButton(
                                  label: context.tr('system_theme'),
                                  isSelected: currentThemeMode == AppThemeMode.system,
                                  onTap: () {
                                    context
                                        .read<ThemeCubit>()
                                        .setThemeMode(AppThemeMode.system);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3. Section: Tài khoản & Bảo mật
                        _buildSectionTitle(context, context.tr('section_account_security')),
                        const SizedBox(height: 8),
                        SettingsListTile(
                          icon: Icons.person_outline_rounded,
                          title: context.tr('edit_profile'),
                          onTap: () => context.push('/edit-profile'),
                        ),
                        SettingsListTile(
                          icon: Icons.lock_outline_rounded,
                          title: context.tr('change_password'),
                          onTap: () => context.push('/change-password'),
                        ),
                        SettingsListTile(
                          icon: Icons.notifications_none_rounded,
                          title: context.tr('notification_settings'),
                        ),
                        const SizedBox(height: 24),

                        // 4. Section: Hỗ trợ & Thông tin
                        _buildSectionTitle(context, context.tr('section_support_info')),
                        const SizedBox(height: 8),
                        SettingsListTile(
                          icon: Icons.help_outline_rounded,
                          title: context.tr('help_feedback'),
                        ),
                        SettingsListTile(
                          icon: Icons.info_outline_rounded,
                          title: context.tr('privacy_policy'),
                        ),
                        const SizedBox(height: 32),

                        // Nút Đăng xuất ở dưới cùng
                        InkWell(
                          onTap: () => _showLogoutDialog(context),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                context.tr('logout'),
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
