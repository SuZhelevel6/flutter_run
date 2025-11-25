import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../logging/app_logger.dart';
import 'settings_state.dart';

/// 设置管理 Cubit
///
/// 管理应用的所有设置项，包括：
/// - 主题模式（亮色/暗色/跟随系统）
/// - 主题色
/// - 字体大小
/// - 语言设置
class SettingsCubit extends Cubit<SettingsState> {
  static const String _storageKey = 'app_settings';

  SettingsCubit() : super(const SettingsState());

  /// 初始化设置（从本地存储加载）
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final loadedState = SettingsState.fromJson(json);
        emit(loadedState);
        AppLogger.info('设置加载成功: $json');
      } else {
        AppLogger.info('未找到已保存的设置，使用默认值');
      }
    } catch (e, stackTrace) {
      AppLogger.error('加载设置失败', e, stackTrace);
    }
  }

  /// 保存设置到本地存储
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      await prefs.setString(_storageKey, jsonString);
      AppLogger.debug('设置已保存: $jsonString');
    } catch (e, stackTrace) {
      AppLogger.error('保存设置失败', e, stackTrace);
    }
  }

  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    AppLogger.info('主题模式切换: ${mode.name}');
    emit(state.copyWith(themeMode: mode));
    await _saveSettings();
  }

  /// 设置主题色
  Future<void> setThemeColor(Color color) async {
    AppLogger.info('主题色切换: #${color.toARGB32().toRadixString(16).padLeft(8, '0')}');
    emit(state.copyWith(themeColor: color));
    await _saveSettings();
  }

  /// 设置字体缩放比例
  Future<void> setFontScale(double scale) async {
    AppLogger.info('字体缩放比例设置: $scale');
    emit(state.copyWith(fontScale: scale));
    await _saveSettings();
  }

  /// 设置语言
  Future<void> setLanguage(String? languageCode) async {
    AppLogger.info('语言设置: ${languageCode ?? "跟随系统"}');
    emit(state.copyWith(languageCode: languageCode));
    await _saveSettings();
  }

  /// 重置为默认设置
  Future<void> reset() async {
    AppLogger.info('重置为默认设置');
    emit(const SettingsState());
    await _saveSettings();
  }
}
