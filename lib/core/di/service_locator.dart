import 'package:get_it/get_it.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';
import 'package:snapspot/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:snapspot/features/feed/domain/repositories/feed_repository.dart';
import 'package:snapspot/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:snapspot/features/map/domain/repositories/map_repository.dart';
import 'package:snapspot/features/map/data/repositories/map_repository_impl.dart';
import 'package:snapspot/features/chat/domain/repositories/chat_repository.dart';
import 'package:snapspot/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:snapspot/core/theme/theme_cubit.dart';
import 'package:snapspot/core/localization/language_cubit.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';
import 'package:snapspot/features/map/presentation/blocs/map_cubit.dart';
import 'package:snapspot/features/chat/presentation/blocs/chat_cubit.dart';
import 'package:snapspot/features/camera/presentation/blocs/post_editor_cubit.dart';

import 'package:snapspot/features/profile/presentation/blocs/collections_cubit.dart';

/// Khai báo Service Locator toàn cục của ứng dụng.
final GetIt getIt = GetIt.instance;

/// Khởi tạo và đăng ký các Dependencies của hệ thống.
void setupServiceLocator() {
  // 1. Đăng ký các Repositories (Lazy Singletons)
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<FeedRepository>(() => FeedRepositoryImpl());
  getIt.registerLazySingleton<MapRepository>(() => MapRepositoryImpl());
  getIt.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());

  // 2. Đăng ký các Cubits
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());
  getIt.registerLazySingleton<CollectionsCubit>(() => CollectionsCubit()..fetchCollections());
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory<FeedCubit>(() => FeedCubit(getIt<FeedRepository>()));
  getIt.registerFactory<MapCubit>(() => MapCubit(getIt<MapRepository>()));
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt<ChatRepository>()));
  getIt.registerFactory<PostEditorCubit>(
    () => PostEditorCubit(getIt<FeedRepository>()),
  );
}
