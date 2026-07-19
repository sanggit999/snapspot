import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/localization/language_cubit.dart';
import 'package:snapspot/core/theme/theme_cubit.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';

class ProfileSettingsSheet extends StatelessWidget {
  final bool isMe;
  const ProfileSettingsSheet({super.key, required this.isMe});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr('logout')),
          content: Text(context.tr('logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.tr('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
                context.read<AuthCubit>().logout().then((_) {
                  if (context.mounted) {
                    context.go('/login');
                  }
                });
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(context.tr('logout')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, currentThemeMode) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, currentLocale) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('settings'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cài đặt Ngôn ngữ
                  Text(
                    context.tr('language'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Tiếng Việt 🇻🇳'),
                          selected: currentLocale.languageCode == 'vi',
                          onSelected: (val) {
                            if (val) {
                              context.read<LanguageCubit>().setLanguage('vi');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('English 🇬🇧'),
                          selected: currentLocale.languageCode == 'en',
                          onSelected: (val) {
                            if (val) {
                              context.read<LanguageCubit>().setLanguage('en');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cài đặt Giao diện
                  Text(
                    context.tr('theme_mode'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: Text(context.tr('light_theme')),
                          selected: currentThemeMode == AppThemeMode.light,
                          onSelected: (val) {
                            if (val) {
                              context
                                  .read<ThemeCubit>()
                                  .setThemeMode(AppThemeMode.light);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ChoiceChip(
                          label: Text(context.tr('dark_theme')),
                          selected: currentThemeMode == AppThemeMode.dark,
                          onSelected: (val) {
                            if (val) {
                              context
                                  .read<ThemeCubit>()
                                  .setThemeMode(AppThemeMode.dark);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ChoiceChip(
                          label: Text(context.tr('system_theme')),
                          selected: currentThemeMode == AppThemeMode.system,
                          onSelected: (val) {
                            if (val) {
                              context
                                  .read<ThemeCubit>()
                                  .setThemeMode(AppThemeMode.system);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nút Đăng xuất
                  if (isMe)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Đóng BottomSheet
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text(context.tr('logout')),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
