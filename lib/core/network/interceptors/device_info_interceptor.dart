import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

/// Interceptor [Thứ tự 2]: Đính kèm thông tin thiết bị (User-Agent, X-Device-Info) phục vụ Security Audit Log
class DeviceInfoInterceptor extends Interceptor {
  String? _deviceInfoString;

  Future<String> _getDeviceInfo() async {
    if (_deviceInfoString != null) return _deviceInfoString!;
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceInfoString = 'Android ${androidInfo.version.release} (${androidInfo.model})';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceInfoString = 'iOS ${iosInfo.systemVersion} (${iosInfo.name})';
      } else if (Platform.isWindows) {
        _deviceInfoString = 'Windows Desktop';
      } else {
        _deviceInfoString = 'SnapSpot Mobile App';
      }
    } catch (_) {
      _deviceInfoString = 'SnapSpot App Client';
    }
    return _deviceInfoString!;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final deviceInfo = await _getDeviceInfo();
    options.headers['X-Device-Info'] = deviceInfo;
    options.headers['User-Agent'] = 'SnapSpotMobile/1.0.0 ($deviceInfo)';
    return handler.next(options);
  }
}
