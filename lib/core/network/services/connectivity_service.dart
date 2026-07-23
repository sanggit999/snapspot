import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/notifications/app_toast.dart';

/// Dịch vụ theo dõi kết nối Mạng toàn cục và quản lý hiển thị Top Floating Toast Overlay.
class ConnectivityService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  OverlayEntry? _overlayEntry;
  Timer? _dismissTimer;
  bool _isOffline = false;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Khởi tạo lắng nghe luồng sự kiện trạng thái kết nối Mạng toàn cục
  void initialize(BuildContext context) {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        if (context.mounted) {
          _handleConnectivityChange(context, results);
        }
      },
    );

    // Kiểm tra tức thì trạng thái ban đầu
    _connectivity.checkConnectivity().then(
      (results) {
        if (context.mounted) {
          _handleConnectivityChange(context, results, isInitial: true);
        }
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _removeOverlay();
  }

  /// Kích hoạt hiển thị Toast thủ công khi `ConnectivityInterceptor` bắt lỗi mạng
  void showOfflineToast(BuildContext context) {
    if (!context.mounted) return;
    final loc = AppLocalizations.of(context);
    _showToastOverlay(
      context,
      message: loc.translate('no_internet_connection'),
      status: AppToastStatus.offline,
    );
  }

  void _handleConnectivityChange(
    BuildContext context,
    List<ConnectivityResult> results, {
    bool isInitial = false,
  }) {
    if (!context.mounted) return;
    final hasNoConnection = results.contains(ConnectivityResult.none);
    final loc = AppLocalizations.of(context);

    if (isInitial) {
      _isOffline = hasNoConnection;
      if (hasNoConnection) {
        _showToastOverlay(
          context,
          message: loc.translate('no_internet_connection'),
          status: AppToastStatus.offline,
        );
      }
      return;
    }

    if (hasNoConnection && !_isOffline) {
      // Chuyển từ ONLINE ➔ OFFLINE
      _isOffline = true;
      _showToastOverlay(
        context,
        message: loc.translate('no_internet_connection'),
        status: AppToastStatus.offline,
      );
    } else if (!hasNoConnection && _isOffline) {
      // Chuyển từ OFFLINE ➔ ONLINE
      _isOffline = false;
      _showToastOverlay(
        context,
        message: loc.translate('back_online'),
        status: AppToastStatus.online,
        autoDismissDuration: const Duration(seconds: 3),
      );
    }
  }

  void _showToastOverlay(
    BuildContext context, {
    required String message,
    required AppToastStatus status,
    Duration? autoDismissDuration,
  }) {
    if (!context.mounted) return;
    _dismissTimer?.cancel();
    _removeOverlay();

    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => AppToastWidget(
        message: message,
        status: status,
      ),
    );

    overlayState.insert(_overlayEntry!);

    if (autoDismissDuration != null) {
      _dismissTimer = Timer(autoDismissDuration, () {
        _removeOverlay();
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
