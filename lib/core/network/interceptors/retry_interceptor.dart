import 'dart:async';
import 'package:dio/dio.dart';

/// Interceptor [Thứ tự 7]: Thử lại (Retry) tối đa maxRetries lần nếu gặp lỗi Mạng / Server 502/503/504
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final isServerError = statusCode != null && statusCode >= 502 && statusCode <= 504;
    final isTimeout = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout;

    var retryCount = err.requestOptions.extra['retry_count'] as int? ?? 0;

    if ((isServerError || isTimeout) && retryCount < maxRetries) {
      retryCount++;
      err.requestOptions.extra['retry_count'] = retryCount;

      // Exponential Backoff Delay (1s, 2s, 4s...)
      final delay = retryInterval * retryCount;
      await Future.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          return super.onError(e, handler);
        }
      }
    }

    return handler.next(err);
  }
}
