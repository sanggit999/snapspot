import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:snapspot/core/di/service_locator.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/localization/language_cubit.dart';
import 'package:snapspot/core/theme/app_theme.dart';
import 'package:snapspot/core/theme/theme_cubit.dart';
import 'package:snapspot/core/router/app_router.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';
import 'package:snapspot/features/map/presentation/blocs/map_cubit.dart';
import 'package:snapspot/features/camera/presentation/blocs/post_editor_cubit.dart';
import 'package:snapspot/features/chat/presentation/blocs/chat_cubit.dart';

/// File cấu hình chính chứa MaterialApp và tiêm tất cả các Cubits của hệ thống.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeMode _convertThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => getIt<ThemeCubit>()),
        BlocProvider<LanguageCubit>(create: (context) => getIt<LanguageCubit>()),
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        BlocProvider<FeedCubit>(create: (context) => getIt<FeedCubit>()),
        BlocProvider<MapCubit>(create: (context) => getIt<MapCubit>()),
        BlocProvider<ChatCubit>(create: (context) => getIt<ChatCubit>()),
        BlocProvider<PostEditorCubit>(
          create: (context) => getIt<PostEditorCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                title: 'SnapSpot',
                debugShowCheckedModeBanner: false,
                // Đa ngôn ngữ (Localization)
                locale: locale,
                supportedLocales: const [Locale('vi', ''), Locale('en', '')],
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                // Theme Sáng / Tối
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: _convertThemeMode(themeMode),
                // Điều hướng bằng GoRouter
                routerConfig: goRouter,
              );
            },
          );
        },
      ),
    );
  }
}
