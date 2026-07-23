import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapspot/core/constants/colors.dart';

enum AppToastStatus { offline, online, warning, info }

/// Component Top Floating Toast Overlay cao cấp chuẩn UI/UX 2026.
/// Trượt mượt từ mép trên màn hình SafeArea xuống với hiệu ứng Glassmorphism.
class AppToastWidget extends StatefulWidget {
  final String message;
  final AppToastStatus status;
  final VoidCallback? onDismiss;

  const AppToastWidget({
    super.key,
    required this.message,
    required this.status,
    this.onDismiss,
  });

  @override
  State<AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<AppToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Rung nhẹ haptic feedback khi toast xuất hiện
    if (widget.status == AppToastStatus.offline) {
      HapticFeedback.heavyImpact();
    } else if (widget.status == AppToastStatus.online) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.status) {
      case AppToastStatus.offline:
        return const Color(0xFFE53935); // Đỏ đậm cảnh báo ngắt mạng
      case AppToastStatus.online:
        return const Color(0xFF2E7D32); // Xanh lá bảo đảm đã khôi phục
      case AppToastStatus.warning:
        return const Color(0xFFF57C00); // Cam cảnh báo
      case AppToastStatus.info:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (widget.status) {
      case AppToastStatus.offline:
        return Icons.wifi_off_rounded;
      case AppToastStatus.online:
        return Icons.wifi_rounded;
      case AppToastStatus.warning:
        return Icons.warning_amber_rounded;
      case AppToastStatus.info:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding + 10,
            left: 16,
            right: 16,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _backgroundColor.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _backgroundColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  if (widget.status == AppToastStatus.offline)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
