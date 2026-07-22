import 'package:dio/dio.dart';

/// Interceptor [Thứ tự 4]: Đính kèm API Secret Key bảo mật nếu hệ thống có yêu cầu
class ApiKeyInterceptor extends Interceptor {
  final String? apiKey;

  ApiKeyInterceptor({this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      options.headers['X-API-Key'] = apiKey;
    }
    return handler.next(options);
  }
}
