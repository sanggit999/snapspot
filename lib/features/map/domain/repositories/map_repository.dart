import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Giao diện MapRepository sử dụng lập trình hàm Either.
abstract class MapRepository {
  /// Lấy danh sách địa điểm check-in (spots) trong bán kính quanh một vị trí trung tâm
  Future<Either<Failure, List<PostEntity>>> loadSpotsInRadius(
    double lat,
    double lng,
    double radiusKm,
  );
}
