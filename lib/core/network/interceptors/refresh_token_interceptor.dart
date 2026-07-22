import 'package:dio/dio.dart';
import 'package:snapspot/core/network/services/storage_service.dart';
import 'package:snapspot/core/network/exceptions/network_exception.dart';


/// Interceptor [Thứ tự 6]: Xử lý lỗi HTTP 401 Unauthorized 
/// Tự động gọi API POST /api/v1/auth/refresh/ đổi Token ngầm và Retry lại Request gốc.
class RefreshTokenInterceptor extends Interceptor {
  final StorageService _storageService;
  final String _baseUrl;
  bool _isRefreshing = false;
  final List<({RequestOptions options, RequestInterceptorHandler handler})> _failedQueue = [];

  RefreshTokenInterceptor(this._storageService, this._baseUrl);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;

    // Chỉ xử lý nếu gặp lỗi HTTP 401 Unauthorized
    if (response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      // Nếu lỗi 401 xảy ra ngay tại API Refresh Token hoặc Login -> Hết hạn vĩnh viễn, Đăng xuất người dùng
      if (requestOptions.path.contains('/auth/refresh/') || requestOptions.path.contains('/auth/login/')) {
        await _storageService.clearSession();
        return handler.reject(
          DioException(
            requestOptions: requestOptions,
            error: const UnauthorizedException(),
          ),
        );
      }

      // Đưa request vào hàng đợi nếu đang trong quá trình Refresh
      if (_isRefreshing) {
        return _failedQueue.add((options: requestOptions, handler: handler as dynamic));
      }

      _isRefreshing = true;

      try {
        final refreshToken = await _storageService.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          await _storageService.clearSession();
          _isRefreshing = false;
          return handler.reject(
            DioException(
              requestOptions: requestOptions,
              error: const UnauthorizedException(message: 'Phiên làm việc đã hết hạn.'),
            ),
          );
        }

        // Tạo instance Dio độc lập để gọi API Refresh Token
        final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
        final refreshResponse = await refreshDio.post(
          '/auth/refresh/',
          data: {'refresh_token': refreshToken},
        );

        if (refreshResponse.statusCode == 200 && refreshResponse.data != null) {
          final resData = refreshResponse.data;
          // Parse Envelope {"success": true, "data": {"access_token": "...", "refresh_token": "..."}}
          final dataMap = resData is Map && resData.containsKey('data') ? resData['data'] : resData;

          final newAccessToken = dataMap['access_token'] as String;
          final newRefreshToken = dataMap['refresh_token'] as String;

          // Lưu cặp Token mới vào Storage
          await _storageService.saveAccessToken(newAccessToken);
          await _storageService.saveRefreshToken(newRefreshToken);

          _isRefreshing = false;

          // Phát lại (Retry) Request gốc ban đầu
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryDio = Dio(BaseOptions(baseUrl: _baseUrl));
          final clonedResponse = await retryDio.fetch(requestOptions);
          
          handler.resolve(clonedResponse);

          // Phát lại tất cả các Request nằm trong hàng đợi _failedQueue
          for (final item in _failedQueue) {
            item.options.headers['Authorization'] = 'Bearer $newAccessToken';
            retryDio.fetch(item.options).then(
              (res) => item.handler.resolve(res),
              onError: (e) => item.handler.reject(e as DioException),
            );
          }
          _failedQueue.clear();
          return;
        }
      } catch (refreshErr) {
        _isRefreshing = false;
        _failedQueue.clear();
        await _storageService.clearSession();
        return handler.reject(
          DioException(
            requestOptions: requestOptions,
            error: const UnauthorizedException(message: 'Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.'),
          ),
        );
      }
    }

    return handler.next(err);
  }
}
