/// Lớp cơ sở định nghĩa các lỗi (Failures) trong hệ thống.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Lỗi xảy ra từ phía Server hoặc xử lý Logic nghiệp vụ
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Lỗi xảy ra khi truy cập bộ nhớ cache cục bộ (Hive)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
