import 'package:equatable/equatable.dart';

/// Lớp thực thể đại diện cho một Bộ sưu tập bài viết đã lưu (Domain Layer).
/// Tuân thủ quy chuẩn Clean Architecture: Immutable Entity với [Equatable].
class CollectionEntity extends Equatable {
  final String id;
  final String name;
  final String iconName; // 'bookmark', 'map', 'cafe', 'camera', 'explore', 'heart', 'star'
  final String colorHex; // '#FF6F61', '#4A90E2', '#7ED321', v.v.
  final int postCount;
  final bool isDefault; // Bộ sưu tập mặc định ("Yêu thích")
  final bool isPrivate; // Quyền riêng tư của bộ sưu tập
  final DateTime createdAt;

  const CollectionEntity({
    required this.id,
    required this.name,
    this.iconName = 'bookmark',
    this.colorHex = '#FF6F61',
    this.postCount = 0,
    this.isDefault = false,
    this.isPrivate = false,
    required this.createdAt,
  });

  /// Tạo bản sao bất biến với thuộc tính cập nhật mới
  CollectionEntity copyWith({
    String? id,
    String? name,
    String? iconName,
    String? colorHex,
    int? postCount,
    bool? isDefault,
    bool? isPrivate,
    DateTime? createdAt,
  }) {
    return CollectionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      postCount: postCount ?? this.postCount,
      isDefault: isDefault ?? this.isDefault,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        iconName,
        colorHex,
        postCount,
        isDefault,
        isPrivate,
        createdAt,
      ];
}
