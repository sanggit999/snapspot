import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:snapspot/core/network/exceptions/network_exception.dart';


/// Interceptor [Thứ tự 1]: Kiểm tra kết nối Internet (Wi-Fi / 4G) trước khi gửi Request
class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity;

  ConnectivityInterceptor({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.contains(ConnectivityResult.none)) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: const NoInternetException(),
          type: DioExceptionType.cancel,
        ),
      );
    }
    return handler.next(options);
  }
}
