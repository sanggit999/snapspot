import 'package:dio/dio.dart';
import 'package:snapspot/core/network/services/storage_service.dart';
import 'package:snapspot/core/network/interceptors/connectivity_interceptor.dart';
import 'package:snapspot/core/network/interceptors/device_info_interceptor.dart';
import 'package:snapspot/core/network/interceptors/locale_interceptor.dart';
import 'package:snapspot/core/network/interceptors/api_key_interceptor.dart';
import 'package:snapspot/core/network/interceptors/auth_interceptor.dart';
import 'package:snapspot/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:snapspot/core/network/interceptors/retry_interceptor.dart';
import 'package:snapspot/core/network/interceptors/error_interceptor.dart';
import 'package:snapspot/core/network/interceptors/logger_interceptor.dart';
import 'package:snapspot/core/network/dio/dio_options.dart';
import 'package:snapspot/core/network/dio/certificate_pinning.dart';

class DioFactory {
  final StorageService _storageService;

  DioFactory(this._storageService);

  Dio createDio({String? baseUrl, String? apiKey}) {
    final baseOptions = DioOptionsConfig.getOptions(baseUrl: baseUrl);
    final dio = Dio(baseOptions);

    // Cấu hình Certificate Pinning / SSL
    CertificatePinningConfig.configurePinning(dio);

    // Sắp xếp chuỗi Interceptor Chain theo thứ tự ưu tiên chính xác
    dio.interceptors.addAll([
      ConnectivityInterceptor(),           // 1. Kiểm tra kết nối Mạng
      DeviceInfoInterceptor(),             // 2. Gắn thông tin Thiết bị & User-Agent
      LocaleInterceptor(),                 // 3. Gắn Accept-Language: vi
      ApiKeyInterceptor(apiKey: apiKey),   // 4. Gắn API Secret Key (nếu có)
      AuthInterceptor(_storageService),    // 5. Gắn Authorization: Bearer <access_token>
      RefreshTokenInterceptor(_storageService, baseOptions.baseUrl), // 6. Xoay vòng Token & Retry khi 401
      RetryInterceptor(dio: dio),          // 7. Retry 3 lần khi bị lỗi 502/503/504
      ErrorInterceptor(),                  // 8. Map Envelope Lỗi sang NetworkException
      LoggerInterceptor(),                 // 9. Pretty Logger in Logs
    ]);

    return dio;
  }
}
