import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

/// Cubit quản lý ngôn ngữ (Locale) hiển thị của ứng dụng.
/// Hỗ trợ tiếng Việt ('vi') và tiếng Anh ('en').
class LanguageCubit extends Cubit<Locale> {
  static const String _boxName = 'settingsBox';
  static const String _key = 'languageCode';

  LanguageCubit() : super(const Locale('vi')) {
    _init();
  }

  void _init() {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        final box = Hive.box(_boxName);
        final savedLang = box.get(_key) as String?;
        if (savedLang != null) {
          emit(Locale(savedLang));
          return;
        }
      }

      // Tự động nhận diện ngôn ngữ hệ thống của thiết bị di động (NFR-501)
      final String systemLang = Platform.localeName.split('_')[0].toLowerCase();
      if (systemLang == 'vi' || systemLang == 'en') {
        emit(Locale(systemLang));
      } else {
        emit(const Locale('vi')); // Mặc định là Tiếng Việt
      }
    } catch (e) {
      emit(const Locale('vi'));
    }
  }

  /// Cập nhật ngôn ngữ và lưu cấu hình vào Hive.
  void setLanguage(String languageCode) {
    if (languageCode != 'vi' && languageCode != 'en') return;

    final locale = Locale(languageCode);
    emit(locale);

    try {
      if (Hive.isBoxOpen(_boxName)) {
        Hive.box(_boxName).put(_key, languageCode);
      }
    } catch (_) {}
  }
}
