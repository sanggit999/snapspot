import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

/// Dịch vụ triển khai SSL Pinning (Certificate / Public Key Pinning) tầng Native trên ứng dụng Flutter.
/// Đọc toàn bộ cấu hình động từ biến môi trường --dart-define (không chứa giá trị mặc định để bảo mật mã nguồn).
/// Tuân thủ quy chuẩn bảo mật Mobile Security Standard 2026 (security-rules SKILL.md).
class SslPinningService {
  /// 1. Đọc Domain API và SSL SHA-256 Fingerprints từ biến môi trường --dart-define
  static const String _envApiHost = String.fromEnvironment(
    'API_HOST',
    defaultValue: '',
  );

  static const String _envApiSslPin = String.fromEnvironment(
    'API_SSL_PIN',
    defaultValue: '',
  );

  static const String _envApiSslBackupPin = String.fromEnvironment(
    'API_SSL_BACKUP_PIN',
    defaultValue: '',
  );

  /// 2. Đọc Domain CDN Unsplash và SSL SHA-256 Fingerprint từ biến môi trường --dart-define
  static const String _envCdnHost = String.fromEnvironment(
    'CDN_HOST',
    defaultValue: '',
  );

  static const String _envCdnSslPin = String.fromEnvironment(
    'CDN_SSL_PIN',
    defaultValue: '',
  );

  /// Bảng tra cứu danh sách Pinned SHA-256 Fingerprints theo Domain Host
  static Map<String, List<String>> get _allowedSHA256Fingerprints => {
        if (_envApiHost.isNotEmpty)
          _envApiHost: [
            if (_envApiSslPin.isNotEmpty) _envApiSslPin,
            if (_envApiSslBackupPin.isNotEmpty) _envApiSslBackupPin,
          ],
        if (_envCdnHost.isNotEmpty)
          _envCdnHost: [
            if (_envCdnSslPin.isNotEmpty) _envCdnSslPin,
          ],
      };

  /// Thực hiện kiểm tra SSL Pinning trực tiếp ở tầng Native (Android Security Provider / iOS Security Framework).
  /// Giúp kháng lại các công cụ Reverse Engineering & Proxy như Frida / Objection / Charles Proxy.
  static Future<bool> verifyNativeSslPinning({
    required String serverUrl,
    List<String>? customSha256Fingerprints,
  }) async {
    try {
      final uri = Uri.parse(serverUrl);
      final fingerprints = customSha256Fingerprints ??
          _allowedSHA256Fingerprints[uri.host] ??
          [];

      if (fingerprints.isEmpty) {
        return true;
      }

      final String secureResult = await HttpCertificatePinning.check(
        serverURL: serverUrl,
        allowedSHAFingerprints: fingerprints,
        sha: SHA.SHA256,
        timeout: 30,
      );

      return secureResult == "CONNECTION_SECURE";
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SSL Pinning Native Notice] $e');
        return true;
      }
      return false;
    }
  }

  /// Khởi tạo một HttpClient bảo mật được cấu hình kiểm tra SSL Pinning tự động ở tầng Dart
  static HttpClient createPinnedHttpClient() {
    final client = HttpClient(context: SecurityContext(withTrustedRoots: true));

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      if (kDebugMode) {
        if (host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2') {
          return true;
        }
      }

      final allowedFingerprints = _allowedSHA256Fingerprints[host];
      if (allowedFingerprints != null && allowedFingerprints.isNotEmpty) {
        final serverCertSHA256 = _getCertSHA256(cert);
        final isMatch = allowedFingerprints.contains(serverCertSHA256);

        if (!isMatch) {
          debugPrint(
            '🚨 [SSL Pinning Error] Phát hiện Chứng chỉ SSL không hợp lệ hoặc bị can thiệp MITM từ host: $host',
          );
        }
        return isMatch;
      }

      return false;
    };

    return client;
  }

  /// Tính toán và chuyển đổi chứng chỉ X509Certificate thành định dạng SHA-256 Fingerprint chuẩn
  static String _getCertSHA256(X509Certificate cert) {
    final digest = sha256.convert(cert.der);
    return digest.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(':');
  }
}
