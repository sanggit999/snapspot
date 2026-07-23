import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Interceptor [Thứ tự 9]: Pretty Logger in Log Request/Response/Status Code/Error đẹp mắt ở chế độ Debug
class LoggerInterceptor extends PrettyDioLogger {
  LoggerInterceptor()
      : super(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,  // Bật true để in rõ HTTP Status Code (200 OK, 401, 500) và Headers
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
          enabled: kDebugMode,
        );
}
