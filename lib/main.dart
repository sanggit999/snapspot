import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snapspot/app.dart';
import 'package:snapspot/core/di/service_locator.dart';

void main() async {
  // Đảm bảo các thành phần Flutter binding được khởi tạo trước khi gọi async
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Service Locator (GetIt)
  setupServiceLocator();

  // Khởi tạo Hive để lưu cấu hình cục bộ (Theme, Ngôn ngữ, Tokens)
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');

  // Khởi chạy ứng dụng chính
  runApp(const MyApp());
}
