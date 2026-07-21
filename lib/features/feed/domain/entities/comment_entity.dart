import 'package:equatable/equatable.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Lớp thực thể đại diện cho một bình luận dưới bài đăng (Domain Layer).
/// Đặt độc lập tại lib/features/feed/domain/entities/comment_entity.dart chuẩn Clean Architecture.
class CommentEntity extends Equatable {
  final String id;
  final String postId;
  final UserEntity user;
  final String content;
  final String? mediaUrl;
  final String? parentId;
  final String? rootId;
  final UserEntity? replyToUser;
  final List<CommentEntity> replies;
  final int likesCount;
  final bool isLiked;

  /// Tổng số câu trả lời từ backend (dùng khi API phân trang replies).
  final int? repliesCount;

  /// Độ sâu của comment trong cây hội thoại (0 = Root, 1 = Reply cấp 1, 2 = Reply cấp 2...).
  final int depth;

  /// Trạng thái ghim bình luận.
  final bool isPinned;

  final DateTime createdAt;

  /// Getter trả về tổng số reply thực tế (từ server count hoặc độ dài mảng local).
  int get totalRepliesCount => repliesCount ?? replies.length;

  /// Kiểm tra có câu trả lời hay không.
  bool get hasReplies => replies.isNotEmpty;

  /// Kiểm tra bình luận có đính kèm media hay không.
  bool get hasMedia => mediaUrl != null && mediaUrl!.isNotEmpty;

  /// Kiểm tra người bình luận có phải là tác giả bài viết hay không.
  bool isPostAuthor(String postAuthorId) => user.id == postAuthorId;

  /// Kiểm tra người dùng hiện tại có phải là chủ sở hữu của bình luận hay không.
  bool isCommentOwner(String currentUserId) => user.id == currentUserId;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.user,
    required this.content,
    this.mediaUrl,
    this.parentId,
    this.rootId,
    this.replyToUser,
    this.replies = const [],
    this.likesCount = 0,
    this.isLiked = false,
    this.repliesCount,
    this.depth = 0,
    this.isPinned = false,
    required this.createdAt,
  });

  CommentEntity copyWith({
    String? id,
    String? postId,
    UserEntity? user,
    String? content,
    String? mediaUrl,
    String? parentId,
    String? rootId,
    UserEntity? replyToUser,
    List<CommentEntity>? replies,
    int? likesCount,
    bool? isLiked,
    int? repliesCount,
    int? depth,
    bool? isPinned,
    DateTime? createdAt,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      user: user ?? this.user,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      parentId: parentId ?? this.parentId,
      rootId: rootId ?? this.rootId,
      replyToUser: replyToUser ?? this.replyToUser,
      replies: replies ?? this.replies,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      repliesCount: repliesCount ?? this.repliesCount,
      depth: depth ?? this.depth,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        postId,
        user,
        content,
        mediaUrl,
        parentId,
        rootId,
        replyToUser,
        replies,
        likesCount,
        isLiked,
        repliesCount,
        depth,
        isPinned,
        createdAt,
      ];
}
