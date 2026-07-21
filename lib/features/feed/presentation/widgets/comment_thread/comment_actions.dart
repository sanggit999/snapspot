import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Render thanh tương tác bên dưới bình luận: thời gian, nút Trả lời, nút Tim, nút 3 chấm Tùy chọn.
class CommentActions extends StatelessWidget {
  final DateTime createdAt;
  final bool isLiked;
  final int likesCount;
  final VoidCallback onReply;
  final VoidCallback onLike;

  /// Callback khi người dùng bấm nút 3 chấm (Ghim, Xóa, Báo cáo...)
  final VoidCallback? onOptionsTap;

  /// Static final: tạo DateFormat một lần duy nhất cho toàn bộ app.
  static final _dateFormat = DateFormat('HH:mm dd/MM/yyyy');

  const CommentActions({
    super.key,
    required this.createdAt,
    required this.isLiked,
    required this.likesCount,
    required this.onReply,
    required this.onLike,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _dateFormat.format(createdAt),
            style: const TextStyle(fontSize: 10.5, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onReply,
          child: const Text(
            'Trả lời',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        const Spacer(),
        // Nút Tim tương tác
        GestureDetector(
          onTap: onLike,
          child: Row(
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 14,
                color: isLiked ? Colors.redAccent : Colors.grey,
              ),
              if (likesCount > 0) ...[
                const SizedBox(width: 3),
                Text(
                  '$likesCount',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isLiked ? Colors.redAccent : Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
        // Nút 3 chấm tùy chọn (Ghim / Xóa / Báo cáo)
        if (onOptionsTap != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onOptionsTap,
            child: const Icon(
              Icons.more_horiz_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }
}
