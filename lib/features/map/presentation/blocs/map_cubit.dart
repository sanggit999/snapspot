import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/map/domain/repositories/map_repository.dart';

// --- STATES ---
class MapState extends Equatable {
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

  @override
  List<Object?> get props => [
        visibleSpots,
        selectedSpot,
        centerLat,
        centerLng,
        radiusKm,
        isLoading,
      ];
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

  /// Tải danh sách địa điểm (spots) nằm trong bán kính [newRadius] (hoặc [radiusKm])
  Future<void> loadSpots({
    double? newLat,
    double? newLng,
    double? newRadius,
    double? radiusKm,
  }) async {
    final targetLat = newLat ?? state.centerLat;
    final targetLng = newLng ?? state.centerLng;
    final targetRadius = newRadius ?? radiusKm ?? state.radiusKm;

    emit(state.copyWith(
      isLoading: true,
      centerLat: targetLat,
      centerLng: targetLng,
      radiusKm: targetRadius,
    ));

    final result = await _mapRepository.loadSpotsInRadius(
      targetLat,
      targetLng,
      targetRadius,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (spots) => emit(state.copyWith(
        visibleSpots: spots,
        isLoading: false,
      )),
    );
  }

  /// Cập nhật danh sách spots đã được lọc (dành cho tìm kiếm).
  void updateFilteredSpots(List<PostEntity> spots) {
    emit(state.copyWith(visibleSpots: spots));
  }

  /// Chọn một spot cụ thể để hiển thị card preview trên bản đồ.
  void selectSpot(PostEntity spot) {
    emit(state.copyWith(selectedSpot: spot));
  }

  /// Bỏ chọn spot card.
  void deselectSpot() {
    emit(state.copyWith(clearSelectedSpot: true));
  }

  /// Đóng card preview spot (tương thích alias).
  void clearSelection() {
    deselectSpot();
  }
}
