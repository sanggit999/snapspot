import 'package:dio/dio.dart';

/// Interceptor [Thứ tự 3]: Đính kèm ngôn ngữ mong muốn (Accept-Language: vi/en)
class LocaleInterceptor extends Interceptor {
  final String languageCode;

  LocaleInterceptor({this.languageCode = 'vi'});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = languageCode;
    return handler.next(options);
  }
}
