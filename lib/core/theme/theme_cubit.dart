import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

/// Các chế độ theme được hỗ trợ trong ứng dụng.
enum AppThemeMode { light, dark, system }

/// Cubit chịu trách nhiệm quản lý và thay đổi trạng thái Theme (Sáng/Tối/Hệ thống).
/// Trạng thái được lưu trữ cục bộ vào Hive để duy trì khi mở lại ứng dụng.
class ThemeCubit extends Cubit<AppThemeMode> {
  static const String _boxName = 'settingsBox';
  static const String _key = 'themeMode';

  ThemeCubit() : super(AppThemeMode.system) {
    _init();
  }

  void _init() {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        final box = Hive.box(_boxName);
        final savedMode = box.get(_key, defaultValue: 'system') as String;
        final mode = AppThemeMode.values.firstWhere(
          (e) => e.name == savedMode,
          orElse: () => AppThemeMode.system,
        );
        emit(mode);
      } else {
        // Fallback nếu box chưa mở ở main
        emit(AppThemeMode.system);
      }
    } catch (e) {
      emit(AppThemeMode.system);
    }
  }

  /// Cập nhật chế độ Theme mới và lưu vào Hive.
  void setThemeMode(AppThemeMode mode) {
    emit(mode);
    try {
      if (Hive.isBoxOpen(_boxName)) {
        Hive.box(_boxName).put(_key, mode.name);
      }
    } catch (_) {}
  }
}
