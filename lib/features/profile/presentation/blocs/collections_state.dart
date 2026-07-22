import 'package:equatable/equatable.dart';
import 'package:snapspot/features/profile/domain/entities/collection_entity.dart';

/// State quản lý danh sách bộ sưu tập cá nhân hóa của người dùng.
abstract class CollectionsState extends Equatable {
  const CollectionsState();

  @override
  List<Object?> get props => [];
}

class CollectionsInitial extends CollectionsState {}

class CollectionsLoading extends CollectionsState {}

class CollectionsLoaded extends CollectionsState {
  final List<CollectionEntity> collections;
  final String activeCollectionId; // 'ALL' hoặc ID của bộ sưu tập

  const CollectionsLoaded({
    required this.collections,
    this.activeCollectionId = 'ALL',
  });

  CollectionsLoaded copyWith({
    List<CollectionEntity>? collections,
    String? activeCollectionId,
  }) {
    return CollectionsLoaded(
      collections: collections ?? this.collections,
      activeCollectionId: activeCollectionId ?? this.activeCollectionId,
    );
  }

  @override
  List<Object?> get props => [collections, activeCollectionId];
}

class CollectionsError extends CollectionsState {
  final String message;
  const CollectionsError(this.message);

  @override
  List<Object?> get props => [message];
}
