import 'package:dio/dio.dart';
import 'package:snapspot/core/network/services/storage_service.dart';


/// Interceptor [Thứ tự 5]: Tự động đọc access_token từ StorageService và gắn 'Authorization: Bearer token'
class AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Không thêm Auth Header nếu endpoint nằm trong danh sách bỏ qua (như /login/, /register/, /refresh/)
    final isNoAuthEndpoint = options.extra['no_auth'] == true ||
        options.path.contains('/auth/login/') ||
        options.path.contains('/auth/register/') ||
        options.path.contains('/auth/refresh/');

    if (!isNoAuthEndpoint) {
      final token = await _storageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }
}
