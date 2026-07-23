import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/network/failures.dart';

/// Class cơ sở UseCase cho tất cả các tác vụ nghiệp vụ Clean Architecture trong hệ thống.
/// [TResult]: Kiểu dữ liệu trả về khi thành công.
/// [Params]: Tham số truyền vào cho tác vụ.
abstract class UseCase<TResult, Params> {
  Future<Either<Failure, TResult>> call(Params params);
}

/// Lớp rỗng đại diện cho các UseCase không yêu cầu truyền tham số.
class NoParams {
  const NoParams();
}
