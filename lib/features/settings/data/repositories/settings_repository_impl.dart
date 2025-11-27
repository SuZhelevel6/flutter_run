import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/settings/settings_state.dart';
import '../../domain/repositories/settings_repository.dart';

/// SettingsRepositoryImpl: 设置数据仓库实现
///
/// 使用 SharedPreferences 进行持久化存储
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  /// 存储键名
  static const String _storageKey = 'app_settings';

  /// 构造函数
  ///
  /// 通过依赖注入传入 SharedPreferences 实例
  const SettingsRepositoryImpl(this._prefs);

  @override
  Future<SettingsState> loadSettings() async {
    try {
      final jsonString = _prefs.getString(_storageKey);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final loadedState = SettingsState.fromJson(json);
        AppLogger.info('设置加载成功: $json');
        return loadedState;
      } else {
        AppLogger.info('未找到已保存的设置，使用默认值');
        return const SettingsState();
      }
    } catch (e, stackTrace) {
      AppLogger.error('加载设置失败', e, stackTrace);
      return const SettingsState();
    }
  }

  @override
  Future<void> saveSettings(SettingsState settings) async {
    try {
      final jsonString = jsonEncode(settings.toJson());
      await _prefs.setString(_storageKey, jsonString);
      AppLogger.debug('设置已保存: $jsonString');
    } catch (e, stackTrace) {
      AppLogger.error('保存设置失败', e, stackTrace);
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final currentSettings = await loadSettings();
    final newSettings = currentSettings.copyWith(themeMode: mode);
    await saveSettings(newSettings);
  }

  @override
  Future<void> saveThemeColor(Color color) async {
    final currentSettings = await loadSettings();
    final newSettings = currentSettings.copyWith(themeColor: color);
    await saveSettings(newSettings);
  }

  @override
  Future<void> saveFontScale(double scale) async {
    final currentSettings = await loadSettings();
    final newSettings = currentSettings.copyWith(fontScale: scale);
    await saveSettings(newSettings);
  }

  @override
  Future<void> saveLanguage(String? languageCode) async {
    final currentSettings = await loadSettings();
    final newSettings = currentSettings.copyWith(languageCode: languageCode);
    await saveSettings(newSettings);
  }

  @override
  Future<void> resetSettings() async {
    await saveSettings(const SettingsState());
  }
}
