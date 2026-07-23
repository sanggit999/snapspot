import 'package:dio/dio.dart';
import 'package:snapspot/core/config/app_config.dart';

/// Class cấu hình Dio Options tự động đọc Base URL từ AppConfig (DEV / PROD)
class DioOptionsConfig {
  /// Đọc URL Base mặc định từ AppConfig
  static String get defaultBaseUrl => AppConfig.baseUrl;

  static BaseOptions getOptions({String? baseUrl}) {
    return BaseOptions(
      baseUrl: baseUrl ?? defaultBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }
}
