import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';
import 'package:snapspot/core/network/models/api_response.dart';
import 'package:snapspot/core/network/exceptions/network_exception.dart';


/// Class Client bọc quanh Dio cung cấp các hàm gọi HTTP GET, POST, PUT, DELETE, Upload 
/// Trả về Either`[Failure, T]` theo đúng chuẩn Clean Architecture.
class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  /// HTTP GET Request
  Future<Either<Failure, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      final apiResponse = ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
      );

      return Right(apiResponse.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// HTTP POST Request
  Future<Either<Failure, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      final apiResponse = ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
      );

      return Right(apiResponse.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// HTTP PUT Request
  Future<Either<Failure, T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      final apiResponse = ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
      );

      return Right(apiResponse.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// HTTP DELETE Request
  Future<Either<Failure, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      final apiResponse = ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
      );

      return Right(apiResponse.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Chuyển đổi DioException sang Failure chuẩn Clean Architecture
  Failure _handleDioError(DioException e) {
    final error = e.error;
    if (error is NetworkException) {
      if (error is NoInternetException || error is TimeoutException) {
        return NetworkFailure(error.message, statusCode: error.statusCode);
      }
      if (error is UnauthorizedException) {
        return AuthFailure(error.message, statusCode: error.statusCode);
      }
      if (error is ForbiddenException) {
        return UnauthorizedFailure(error.message, statusCode: error.statusCode);
      }
      return ServerFailure(error.message, statusCode: error.statusCode);
    }
    return ServerFailure(e.message ?? 'Đã xảy ra lỗi mạng không xác định.');
  }
}
