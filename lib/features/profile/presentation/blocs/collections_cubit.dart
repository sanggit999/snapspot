import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/profile/domain/entities/collection_entity.dart';
import 'package:snapspot/features/profile/presentation/blocs/collections_state.dart';

/// Cubit quản lý State nghiệp vụ cho hệ thống Bộ sưu tập động 100% (Clean Architecture & BLoC Pattern).
class CollectionsCubit extends Cubit<CollectionsState> {
  CollectionsCubit() : super(CollectionsInitial());

  /// Tải danh sách bộ sưu tập động của người dùng
  void fetchCollections() {
    emit(CollectionsLoading());
    try {
      final list = List<CollectionEntity>.from(MockData.mockCollections);
      emit(CollectionsLoaded(collections: list));
    } catch (e) {
      emit(CollectionsError('Lỗi khi tải bộ sưu tập: $e'));
    }
  }

  /// Đặt thư mục bộ sưu tập đang được kích hoạt để lọc bài viết
  void setActiveCollection(String collectionId) {
    if (state is CollectionsLoaded) {
      final currentState = state as CollectionsLoaded;
      emit(currentState.copyWith(activeCollectionId: collectionId));
    }
  }

  /// Tạo một Bộ sưu tập mới tùy chỉnh người dùng với Tên, Icon, Màu sắc và Quyền riêng tư
  Future<CollectionEntity?> createCollection({
    required String name,
    String iconName = 'bookmark',
    String colorHex = '#FF6F61',
    bool isPrivate = false,
  }) async {
    if (state is! CollectionsLoaded) return null;

    final currentState = state as CollectionsLoaded;
    final cleanName = name.trim();
    if (cleanName.isEmpty) return null;

    final newCollection = CollectionEntity(
      id: 'col_${DateTime.now().millisecondsSinceEpoch}',
      name: cleanName,
      iconName: iconName,
      colorHex: colorHex,
      postCount: 0,
      isDefault: false,
      isPrivate: isPrivate,
      createdAt: DateTime.now(),
    );

    MockData.mockCollections.add(newCollection);
    final updatedList = List<CollectionEntity>.from(currentState.collections)..add(newCollection);

    emit(currentState.copyWith(
      collections: updatedList,
      activeCollectionId: newCollection.id,
    ));

    return newCollection;
  }

  /// Chỉnh sửa tên, icon, màu sắc hoặc quyền riêng tư của Bộ sưu tập
  Future<CollectionEntity?> updateCollection({
    required String id,
    required String name,
    required String iconName,
    required String colorHex,
    required bool isPrivate,
  }) async {
    if (state is! CollectionsLoaded) return null;

    final currentState = state as CollectionsLoaded;
    final cleanName = name.trim();
    if (cleanName.isEmpty) return null;

    final index = MockData.mockCollections.indexWhere((c) => c.id == id);
    if (index == -1) return null;

    final oldCol = MockData.mockCollections[index];
    final updatedCol = oldCol.copyWith(
      name: cleanName,
      iconName: iconName,
      colorHex: colorHex,
      isPrivate: isPrivate,
    );

    MockData.mockCollections[index] = updatedCol;

    // Cập nhật tên bộ sưu tập trong danh sách bài đăng đã lưu của MockData nếu đổi tên
    if (oldCol.name != cleanName) {
      for (int i = 0; i < MockData.mockPosts.length; i++) {
        if (MockData.mockPosts[i].savedCollectionName == oldCol.name) {
          MockData.mockPosts[i] = MockData.mockPosts[i].copyWith(
            savedCollectionName: cleanName,
          );
        }
      }
    }

    final updatedList = List<CollectionEntity>.from(MockData.mockCollections);

    emit(currentState.copyWith(
      collections: updatedList,
      activeCollectionId: updatedCol.id,
    ));

    return updatedCol;
  }

  /// Xóa một Bộ sưu tập bài viết đã lưu. Tất cả bài viết thuộc thư mục này được trả về mục "Tất cả" (null)
  Future<bool> deleteCollection(String id) async {
    if (state is! CollectionsLoaded) return false;

    final currentState = state as CollectionsLoaded;
    final index = MockData.mockCollections.indexWhere((c) => c.id == id);
    if (index == -1) return false;

    final targetCol = MockData.mockCollections[index];

    // Xóa bộ sưu tập khỏi MockData
    MockData.mockCollections.removeAt(index);

    // Trả tất cả bài viết trong thư mục này về danh mục chung "Tất cả" (savedCollectionName = null)
    for (int i = 0; i < MockData.mockPosts.length; i++) {
      if (MockData.mockPosts[i].savedCollectionName == targetCol.name) {
        MockData.mockPosts[i] = MockData.mockPosts[i].copyWith(
          savedCollectionName: null,
        );
      }
    }

    final updatedList = List<CollectionEntity>.from(MockData.mockCollections);

    emit(currentState.copyWith(
      collections: updatedList,
      activeCollectionId: 'ALL',
    ));

    return true;
  }

  /// Cập nhật đếm số lượng bài đăng trong bộ sưu tập
  void updateCollectionPostCounts(Map<String, int> countsByName) {
    if (state is CollectionsLoaded) {
      final currentState = state as CollectionsLoaded;
      final updatedList = currentState.collections.map((col) {
        final count = countsByName[col.name] ?? col.postCount;
        return col.copyWith(postCount: count);
      }).toList();

      emit(currentState.copyWith(collections: updatedList));
    }
  }
}
