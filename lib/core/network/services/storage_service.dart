import 'package:snapspot/core/security/secure_storage_service.dart';

/// Adapter StorageService bọc quanh SecureStorageService (lib/core/security/) 
/// phục vụ Tầng Mạng Network Layer theo chuẩn Clean Architecture.
class StorageService {
  Future<void> saveAccessToken(String token) async {
    await SecureStorageService.saveAccessToken(token);
  }

  Future<String?> getAccessToken() async {
    return await SecureStorageService.getAccessToken();
  }

  Future<void> saveRefreshToken(String token) async {
    await SecureStorageService.saveRefreshToken(token);
  }

  Future<String?> getRefreshToken() async {
    return await SecureStorageService.getRefreshToken();
  }

  Future<void> saveUserInfo({required int userId, required String email}) async {
    await SecureStorageService.saveUserInfo(userId: userId.toString(), email: email);
  }

  Future<int?> getUserId() async {
    final idStr = await SecureStorageService.getUserId();
    return idStr != null ? int.tryParse(idStr) : null;
  }

  Future<void> clearSession() async {
    await SecureStorageService.clearSession();
  }

  Future<void> clearAll() async {
    await SecureStorageService.clearAll();
  }
}
