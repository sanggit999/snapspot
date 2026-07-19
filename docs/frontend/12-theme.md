# 12 - Theme

Tài liệu này hướng dẫn cách cấu hình và triển khai chế độ sáng/tối (Light/Dark Theme) trong ứng dụng Flutter của SnapSpot.

---

## 1. Cấu hình màu sắc theo Chế độ (ColorScheme Mapping)

Ứng dụng hỗ trợ hai cấu hình màu sắc tương phản giúp bảo vệ mắt người dùng vào ban đêm.

### 1.1. Chế độ sáng (Light Theme ColorScheme)
- `primary`: `#FF6F61` (Cam San Hô)
- `onPrimary`: `#FFFFFF`
- `secondary`: `#4EA8DE` (Xanh Teal)
- `background`: `#F8F9FA`
- `surface`: `#FFFFFF`
- `onBackground`: `#1A1A1A`
- `onSurface`: `#1A1A1A`

### 1.2. Chế độ tối (Dark Theme ColorScheme)
- `primary`: `#FF6F61` (Cam San Hô)
- `onPrimary`: `#FFFFFF`
- `secondary`: `#4EA8DE` (Xanh Teal)
- `background`: `#121212`
- `surface`: `#1E1E1E`
- `onBackground`: `#F8F9FA`
- `onSurface`: `#F8F9FA`

---

## 2. Quy chuẩn cấu hình thành phần trong Flutter (Component Styling)

Khi cấu hình `ThemeData`, tránh viết cứng (hardcode) màu sắc trong Widget. Luôn liên kết với `Theme.of(context)` để tự động thay đổi khi chuyển chế độ sáng/tối.

### 2.1. AppBarTheme
- **Light**: Background màu `#FFFFFF`, chữ màu `#1A1A1A`, không đổ bóng (`elevation: 0`).
- **Dark**: Background màu `#1E1E1E`, chữ màu `#F8F9FA`, không đổ bóng (`elevation: 0`).

### 2.2. CardTheme
- Góc bo tròn (`shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))`).
- **Light**: Đổ bóng mờ mịn (`shadowColor: Colors.black.withOpacity(0.05)`, `elevation: 4`).
- **Dark**: Không đổ bóng (`elevation: 0`), phân tách bằng màu nền `surface` tối hơn nền chung.

### 2.3. InputDecorationTheme (Ô nhập liệu)
- Bo góc 8dp, có viền mỏng bao quanh.
- Khi hoạt động (focus): Viền chuyển sang màu `primary`.
- Khi có lỗi (error): Viền chuyển sang màu `error`.

---

## 3. Cơ chế Chuyển đổi Theme (Theme Controller)

Trạng thái Theme được quản lý bởi **ThemeCubit (Cubit)** và lưu trữ cục bộ vào cơ sở dữ liệu Hive để duy trì trạng thái khi người dùng mở lại app.

```dart
// Enum định nghĩa trạng thái Theme
enum AppThemeMode { light, dark, system }

class ThemeCubit extends Cubit<AppThemeMode> {
  static const _boxName = 'settingsBox';
  static const _key = 'themeMode';

  ThemeCubit() : super(AppThemeMode.system) {
    _init();
  }

  void _init() {
    final box = Hive.box(_boxName);
    final savedMode = box.get(_key, defaultValue: 'system');
    final mode = AppThemeMode.values.firstWhere(
      (e) => e.name == savedMode,
      orElse: () => AppThemeMode.system,
    );
    emit(mode);
  }

  void setThemeMode(AppThemeMode mode) {
    emit(mode);
    Hive.box(_boxName).put(_key, mode.name);
  }
}
```

### Cách áp dụng tại root `app.dart`
```dart
@override
Widget build(BuildContext context) {
  return BlocBuilder<ThemeCubit, AppThemeMode>(
    builder: (context, themeMode) {
      return MaterialApp(
        title: 'SnapSpot',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _convertThemeMode(themeMode),
        routerConfig: goRouter,
      );
    },
  );
}
```