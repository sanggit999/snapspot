import 'dart:io';
import 'package:flutter/foundation.dart';

/// Lớp quản lý Cấu Hình Môi Trường API Server cho SnapSpot Mobile Client.
/// Thiết kế dạng CÔNG TẮC BẬT / TẮT (Comment / Uncomment) trực tiếp, 
/// giúp kiểm soát 100% an toàn tuyệt đối khi phát hành ứng dụng lên Google Play / App Store.
class AppConfig {
  AppConfig._();

  // ===========================================================================
  // 🔘 CÔNG TẮC CHUYỂN ĐỔI MÔI TRƯỜNG (DỄ DÀNG KIỂM SOÁT KHI UP STORE)
  // ===========================================================================
  
  /// 👉 ĐANG CHẠY MÔI TRƯỜNG DEV (Lập trình & Test local)
  static const bool _isProductionMode = false;

  /// 👉 KHI LÊN CỬA HÀNG (RELEASE APP STORE / GOOGLE PLAY): 
  /// Đổi `false` thành `true` ở dòng trên (hoặc bỏ comment dòng bên dưới):
  // static const bool _isProductionMode = true;

  // ===========================================================================
  // 🌐 DÂN CƯ CẤU HÌNH API BASE URL TƯỜNG MINH
  // ===========================================================================

  /// 1. MÔI TRƯỜNG DEVELOPMENT (DEV)
  static const String devPhysicalDeviceUrl = 'http://192.168.1.17:8000/api/v1'; // Máy thật Wi-Fi
  static const String devEmulatorUrl       = 'http://10.0.2.2:8000/api/v1';     // Máy ảo Emulator
  static const String devLocalhostUrl      = 'http://localhost:8000/api/v1';    // Web / Desktop

  /// 2. MÔI TRƯỜNG PRODUCTION (PROD - CHÍNH THỨC CỬA HÀNG STORE)
  static const String prodBaseUrl          = 'https://api.snapspot.com/api/v1';
  static const String prodCdnUrl           = 'https://cdn.snapspot.com';

  // ===========================================================================
  // ⚙️ TỰ ĐỘNG XỬ LÝ LẤY BASE URL
  // ===========================================================================
  
  static bool get isProd => _isProductionMode;
  static bool get isDev => !_isProductionMode;

  /// Lấy URL Dev phù hợp với thiết bị chạy (Android, iOS, Web, Desktop)
  static String get devBaseUrl {
    if (kIsWeb) return devLocalhostUrl;

    // Trên thiết bị di động (Android thật hoặc iOS thật bắt cùng Wi-Fi):
    if (Platform.isAndroid || Platform.isIOS) {
      // Đổi sang devEmulatorUrl nếu dùng Android Emulator, hoặc devLocalhostUrl nếu dùng iOS Simulator
      return devPhysicalDeviceUrl;
    }

    return devLocalhostUrl;
  }

  /// Lấy Base URL chính thức được sử dụng
  static String get baseUrl {
    // Ưu tiên cao nhất nếu truyền tùy chỉnh từ command line --dart-define=BASE_URL=...
    const envBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    return _isProductionMode ? prodBaseUrl : devBaseUrl;
  }

  /// In Log kiểm tra môi trường khi ứng dụng khởi chạy
  static void logConfig() {
    final modeBanner = isProd
        ? '🔴 PRODUCTION (CHÍNH THỨC CỬA HÀNG STORE)'
        : '🟢 DEVELOPMENT (DEV LOCAL KIỂM THỬ)';

    debugPrint('======================================================================');
    debugPrint('🚀 [SnapSpot Config] MÔI TRƯỜNG HIỆN TẠI : $modeBanner');
    debugPrint('🌐 [SnapSpot Config] BASE API URL TRỎ ĐẾN: $baseUrl');
    debugPrint('======================================================================');
  }
}
