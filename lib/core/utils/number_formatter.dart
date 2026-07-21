/// Utility class để định dạng số đếm hiển thị mượt mà trên UI (Ví dụ: Likes, Comments, Views).
class NumberFormatter {
  const NumberFormatter._();

  /// Định dạng số nguyên thành chuỗi rút gọn thân thiện chuẩn mạng xã hội (Compact Format):
  /// - `950` -> `950`
  /// - `1200` -> `1.2K`
  /// - `15800` -> `15.8K`
  /// - `1500000` -> `1.5M`
  /// - `2300000000` -> `2.3B`
  static String formatCompact(int number) {
    if (number <= 0) return '0';
    if (number < 1000) return '$number';

    if (number < 1000000) {
      final double result = number / 1000.0;
      return result % 1 == 0
          ? '${result.toInt()}K'
          : '${result.toStringAsFixed(1)}K';
    }

    if (number < 1000000000) {
      final double result = number / 1000000.0;
      return result % 1 == 0
          ? '${result.toInt()}M'
          : '${result.toStringAsFixed(1)}M';
    }

    final double result = number / 1000000000.0;
    return result % 1 == 0
        ? '${result.toInt()}B'
        : '${result.toStringAsFixed(1)}B';
  }
}
