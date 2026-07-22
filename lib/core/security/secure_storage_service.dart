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

  static const String _accessTokenKey = 'secure_access_token';
  static const String _refreshTokenKey = 'secure_refresh_token';
  static const String _userIdKey = 'secure_logged_in_user_id';
  static const String _userEmailKey = 'secure_user_email';

  /// Lưu trữ Access Token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Đọc Access Token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Lưu trữ Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Đọc Refresh Token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Lưu trữ User Info
  static Future<void> saveUserInfo({required String userId, required String email}) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Lưu trữ User ID đăng nhập
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Đọc User ID đăng nhập
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Đọc User Email đăng nhập
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// Tiêu hủy session đăng nhập
  static Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
  }

  /// Tiêu hủy toàn bộ dữ liệu nhạy cảm khi Đăng xuất (Data Retention Compliance)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
