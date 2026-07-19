import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/core/network/mock_data.dart';
import 'package:snapspot/core/utils/geo_utils.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/map/domain/repositories/map_repository.dart';

/// Triển khai MapRepositoryImpl sử dụng fpdart Either.
class MapRepositoryImpl implements MapRepository {
  @override
  Future<Either<Failure, List<PostEntity>>> loadSpotsInRadius(
    double lat,
    double lng,
    double radiusKm,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final allPosts = MockData.mockPosts;
      final visible = allPosts.where((post) {
        final dist = GeoUtils.calculateDistance(
          lat,
          lng,
          post.latitude,
          post.longitude,
        );
        return dist <= radiusKm;
      }).toList();

      return Right(visible);
    } catch (e) {
      return Left(ServerFailure('Lỗi tải địa điểm bản đồ: $e'));
    }
  }
}
