import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Dịch vụ quản lý bộ lưu trữ an toàn mã hóa phần cứng (Android Keystore / iOS Keychain).
/// Tuân thủ quy chuẩn bảo mật Mobile Security Standard 2026 (security-rules SKILL.md).
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _tokenKey = 'secure_access_token';
  static const String _userIdKey = 'secure_logged_in_user_id';

  /// Lưu trữ Access Token vào Secure Storage được mã hóa phần cứng
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Đọc Access Token đã mã hóa từ Secure Storage
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Lưu trữ User ID đăng nhập
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Đọc User ID đăng nhập từ Secure Storage
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Tiêu hủy toàn bộ dữ liệu nhạy cảm khi Đăng xuất (Data Retention & Logout Compliance)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
