import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioOptionsConfig {
  static String get defaultBaseUrl {
    if (kIsWeb) return 'http://localhost:8000/api/v1';
    if (Platform.isAndroid) {
      // Android Emulator kết nối host machine qua IP 10.0.2.2
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://localhost:8000/api/v1';
  }

  static BaseOptions getOptions({String? baseUrl}) {
    return BaseOptions(
      baseUrl: baseUrl ?? defaultBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }
}
