import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/map/domain/repositories/map_repository.dart';

// --- STATES ---
class MapState {
  final List<PostEntity> visibleSpots; // Các spots đang hiện trên khu vực map
  final PostEntity? selectedSpot; // Spot đang được chọn để xem preview card
  final double centerLat; // Toạ độ vĩ độ tâm bản đồ
  final double centerLng; // Toạ độ kinh độ tâm bản đồ
  final double radiusKm; // Bán kính quét xung quanh tâm
  final bool isLoading; // Trạng thái đang quét/load

  const MapState({
    required this.visibleSpots,
    this.selectedSpot,
    required this.centerLat,
    required this.centerLng,
    required this.radiusKm,
    this.isLoading = false,
  });

  MapState copyWith({
    List<PostEntity>? visibleSpots,
    PostEntity? selectedSpot,
    bool clearSelectedSpot = false,
    double? centerLat,
    double? centerLng,
    double? radiusKm,
    bool? isLoading,
  }) {
    return MapState(
      visibleSpots: visibleSpots ?? this.visibleSpots,
      selectedSpot:
          clearSelectedSpot ? null : (selectedSpot ?? this.selectedSpot),
      centerLat: centerLat ?? this.centerLat,
      centerLng: centerLng ?? this.centerLng,
      radiusKm: radiusKm ?? this.radiusKm,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// --- CUBIT ---
class MapCubit extends Cubit<MapState> {
  final MapRepository _mapRepository;

  MapCubit(this._mapRepository)
      : super(
          const MapState(
            visibleSpots: [],
            centerLat: 10.7769,
            centerLng: 106.7009,
            radiusKm: 15.0,
          ),
        ) {
    loadSpots();
  }

  /// Tải danh sách địa điểm (spots) nằm trong bán kính [radiusKm] so với vị trí trung tâm bản đồ.
  Future<void> loadSpots({
    double? newLat,
    double? newLng,
    double? newRadius,
  }) async {
    emit(state.copyWith(isLoading: true));

    final double lat = newLat ?? state.centerLat;
    final double lng = newLng ?? state.centerLng;
    final double rad = newRadius ?? state.radiusKm;

    final result = await _mapRepository.loadSpotsInRadius(lat, lng, rad);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (visible) {
        emit(
          MapState(
            visibleSpots: visible,
            selectedSpot: visible.isNotEmpty ? visible[0] : null,
            centerLat: lat,
            centerLng: lng,
            radiusKm: rad,
            isLoading: false,
          ),
        );
      },
    );
  }

  /// Chọn một Spot cụ thể để hiển thị Preview Card ở dưới cùng
  void selectSpot(PostEntity spot) {
    emit(state.copyWith(selectedSpot: spot));
  }

  /// Bỏ chọn Spot (Đóng Preview Card)
  void deselectSpot() {
    emit(state.copyWith(clearSelectedSpot: true));
  }

  /// Cập nhật tâm bản đồ khi kéo thả
  void updateCenter(double lat, double lng) {
    loadSpots(newLat: lat, newLng: lng);
  }

  /// Cập nhật danh sách spots đã lọc (phục vụ tính năng tìm kiếm trên UI)
  void updateFilteredSpots(List<PostEntity> filtered) {
    emit(state.copyWith(
      visibleSpots: filtered,
      selectedSpot: filtered.isNotEmpty ? filtered[0] : null,
    ));
  }
}
