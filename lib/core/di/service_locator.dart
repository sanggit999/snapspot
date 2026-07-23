import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:snapspot/core/network/services/storage_service.dart';
import 'package:snapspot/core/network/services/connectivity_service.dart';
import 'package:snapspot/core/network/dio/dio_factory.dart';
import 'package:snapspot/core/network/dio/dio_client.dart';
import 'package:snapspot/features/auth/domain/repositories/auth_repository.dart';
import 'package:snapspot/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:snapspot/features/auth/domain/usecases/login_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/register_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/logout_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:snapspot/features/auth/domain/usecases/change_password_usecase.dart';
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
  // 1. Core Network & Storage Services (Singletons)
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<DioFactory>(() => DioFactory(getIt<StorageService>()));
  getIt.registerLazySingleton<Dio>(() => getIt<DioFactory>().createDio());
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));

  // 2. Đăng ký các Repositories (Lazy Singletons)
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dioClient: getIt<DioClient>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerLazySingleton<FeedRepository>(() => FeedRepositoryImpl());
  getIt.registerLazySingleton<MapRepository>(() => MapRepositoryImpl());
  getIt.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());

  // 3. Đăng ký các UseCases (Lazy Singletons)
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<CheckAuthStatusUseCase>(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<UpdateProfileUseCase>(() => UpdateProfileUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ChangePasswordUseCase>(() => ChangePasswordUseCase(getIt<AuthRepository>()));

  // 4. Đăng ký các Cubits (AuthCubit là LazySingleton duy nhất quản lý trạng thái Auth toàn app)
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());
  getIt.registerLazySingleton<CollectionsCubit>(() => CollectionsCubit()..fetchCollections());

  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
    ),
  );

  getIt.registerFactory<FeedCubit>(() => FeedCubit(getIt<FeedRepository>()));
  getIt.registerFactory<MapCubit>(() => MapCubit(getIt<MapRepository>()));
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt<ChatRepository>()));
  getIt.registerFactory<PostEditorCubit>(
    () => PostEditorCubit(getIt<FeedRepository>()),
  );
}
