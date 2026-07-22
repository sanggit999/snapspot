import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:snapspot/core/security/ssl_pinning_service.dart';

/// Certificate Pinning Security config cho Dio Client tích hợp SslPinningService
class CertificatePinningConfig {
  static void configurePinning(Dio dio) {
    if (kIsWeb) return;

    // Tích hợp SslPinningService từ lib/core/security/ bảo mật tầng Native
    (dio.httpClientAdapter as dynamic).onHttpClientCreate = (HttpClient client) {
      return SslPinningService.createPinnedHttpClient();
    };
  }
}
