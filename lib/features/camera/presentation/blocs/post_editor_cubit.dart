import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/mappers/auth/user_mapper.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/mappers/feed/post_mapper.dart';
import 'package:snapspot/features/feed/data/models/post_model.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/domain/repositories/feed_repository.dart';

// --- STATES ---
abstract class PostEditorState {
  const PostEditorState();
}

class PostEditorInitial extends PostEditorState {
  const PostEditorInitial();
}

class PostEditorUploading extends PostEditorState {
  final double progress; // Tiến trình tải lên từ 0.0 đến 1.0
  const PostEditorUploading(this.progress);
}

class PostEditorSuccess extends PostEditorState {
  final PostEntity createdPost;
  const PostEditorSuccess(this.createdPost);
}

class PostEditorFailure extends PostEditorState {
  final String message;
  const PostEditorFailure(this.message);
}

// --- CUBIT ---
class PostEditorCubit extends Cubit<PostEditorState> {
  final FeedRepository _feedRepository;

  PostEditorCubit(this._feedRepository) : super(const PostEditorInitial());

  /// Thực hiện tải bài đăng mới lên.
  /// Mô phỏng tiến trình tải lên bất đồng bộ nền (NFR / Functional spec)
  Future<void> uploadPost({
    required String caption,
    required List<String> imageUrls,
    required double latitude,
    required double longitude,
    required String locationName,
    required UserEntity currentUser,
    required List<String> hashtags,
  }) async {
    try {
      // Bắt đầu mô phỏng tiến trình upload từ 10% đến 100%
      for (double p = 0.1; p <= 1.0; p += 0.3) {
        emit(PostEditorUploading(p > 1.0 ? 1.0 : p));
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Dùng UserMapper để chuyển Entity → Model (Data Layer)
      final userModel = UserMapper.fromEntity(currentUser);
      final newPostModel = PostModel(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        caption: caption,
        imageUrls: imageUrls,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        user: userModel,
        hashtags: hashtags,
        likesCount: 0,
        commentsCount: 0,
        isLiked: false,
        createdAt: DateTime.now(),
        comments: const [],
      );

      // Dùng PostMapper để chuyển Model → Entity trước khi gửi vào Repository
      final newPostEntity = PostMapper.toEntity(newPostModel);

      final result = await _feedRepository.addNewPost(newPostEntity);
      result.fold(
        (failure) => emit(PostEditorFailure(failure.message)),
        (_) => emit(PostEditorSuccess(newPostEntity)),
      );
    } catch (e) {
      emit(PostEditorFailure(e.toString()));
    }
  }

  void reset() {
    emit(const PostEditorInitial());
  }
}
