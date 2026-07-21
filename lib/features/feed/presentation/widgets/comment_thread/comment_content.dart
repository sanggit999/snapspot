import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Render bubble nội dung bình luận: tên người đăng [Badge Tác giả] [▶ tên người reply] [Badge Ghim], text, media.
class CommentContent extends StatelessWidget {
  final String authorName;
  final String? replyToName;
  final String text;
  final String? mediaUrl;
  final bool isLight;

  /// True nếu người comment chính là Tác giả bài viết (OP).
  final bool isAuthor;

  /// True nếu bình luận này được ghim lên đầu.
  final bool isPinned;

  const CommentContent({
    super.key,
    required this.authorName,
    this.replyToName,
    required this.text,
    required this.isLight,
    this.isAuthor = false,
    this.isPinned = false,
    this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary;
    final primaryColor = isLight ? AppColors.primary : Colors.blue.shade300;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isLight ? Colors.grey[100] : Colors.grey[900],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tên tác giả comment [Badge Tác giả] [▶ Tên người được reply] [Badge Đã ghim]
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 2,
            children: [
              // 1. Tên người đăng comment
              Text(
                authorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: textColor,
                ),
              ),

              // 2. Badge "Tác giả" - đặt NGAY SAU tên người comment để đúng logic UI/UX
              if (isAuthor)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    'Tác giả',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),

              // 3. Icon mũi tên & Tên người được trả lời (nếu có)
              if (replyToName != null && replyToName!.isNotEmpty) ...[
                const Icon(
                  Icons.play_arrow_rounded,
                  size: 13,
                  color: Colors.grey,
                ),
                Text(
                  replyToName!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
              ],

              // 4. Badge "Đã ghim" (nếu isPinned == true)
              if (isPinned)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.amber.shade700.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.push_pin_rounded,
                        size: 10,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Đã ghim',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: textColor,
              ),
            ),
          ],
          if (mediaUrl != null) ...[
            const SizedBox(height: 8),
            // Media được bọc trong RepaintBoundary để tránh repaint bubble khi cuộn.
            RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: mediaUrl!,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 120,
                    color: Colors.grey[800],
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image_outlined, size: 30),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
