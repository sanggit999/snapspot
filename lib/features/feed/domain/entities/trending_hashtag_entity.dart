import 'package:equatable/equatable.dart';

/// Lớp thực thể đại diện cho một Hashtag Xu Hướng (Trending Hashtag) chuẩn Domain Layer.
class TrendingHashtagEntity extends Equatable {
  final String tagKey; // Mã nhận diện tag ('ALL', 'hanoi', 'travel'...)
  final int postCount; // Số lượng bài viết gắn tag này
  final String displayLabel; // Nhãn hiển thị ("✨ Tất cả (12)", "🔥 #hanoi (15)")
  final bool isRecommended; // Đề xuất cho người dùng dựa trên sở thích

  const TrendingHashtagEntity({
    required this.tagKey,
    required this.postCount,
    required this.displayLabel,
    this.isRecommended = false,
  });

  @override
  List<Object?> get props => [tagKey, postCount, displayLabel, isRecommended];
}
