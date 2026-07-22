import 'package:dio/dio.dart';
import 'package:snapspot/core/network/exceptions/network_exception.dart';
import 'package:snapspot/core/network/models/api_error_response.dart';


/// Interceptor [Thứ tự 8]: Map DioException sang Custom NetworkException chuẩn hóa
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is NetworkException) {
      return handler.next(err);
    }

    NetworkException customException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        customException = const TimeoutException();
        break;

      case DioExceptionType.cancel:
        customException = const NoInternetException();
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;

        String message = 'Đã xảy ra lỗi hệ thống.';
        String errorCode = 'UNKNOWN_ERROR';
        dynamic details;

        if (data is Map<String, dynamic>) {
          final parsedError = ApiErrorResponse.fromJson(data);
          message = parsedError.message;
          errorCode = parsedError.code;
          details = parsedError.details;
        }

        switch (statusCode) {
          case 401:
            customException = UnauthorizedException(
              message: message,
              statusCode: 401,
              errorCode: errorCode,
              details: details,
            );
            break;

          case 403:
            customException = ForbiddenException(
              message: message,
              statusCode: 403,
              errorCode: errorCode,
              details: details,
            );
            break;

          case 404:
            customException = NotFoundException(
              message: message,
              statusCode: 404,
              errorCode: errorCode,
              details: details,
            );
            break;

          default:
            customException = NetworkException(
              message: message,
              statusCode: statusCode,
              errorCode: errorCode,
              details: details,
            );
        }
        break;

      case DioExceptionType.connectionError:
        customException = const NoInternetException();
        break;

      default:
        customException = NetworkException(
          message: err.message ?? 'Đã xảy ra lỗi kết nối mạng.',
        );
    }

    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: customException,
    );

    return handler.next(newError);
  }
}
