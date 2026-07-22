import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Interceptor [Thứ tự 9]: Pretty Logger in Log Request/Response/Error đẹp mắt ở chế độ Debug
class LoggerInterceptor extends PrettyDioLogger {
  LoggerInterceptor()
      : super(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
          enabled: kDebugMode,
        );
}
