import 'package:flutter/material.dart';
import '../../../../core/settings/settings_state.dart';

/// SettingsRepository: 设置数据仓库接口
///
/// 定义设置模块的数据访问接口，遵循依赖倒置原则:
/// - Cubit 依赖此接口
/// - Data 层实现此接口
///
/// 职责:
/// - 加载设置
/// - 保存设置
/// - 提供设置的持久化抽象
abstract class SettingsRepository {
  /// 加载设置
  ///
  /// 从持久化存储加载设置，如果不存在则返回默认设置
  Future<SettingsState> loadSettings();

  /// 保存设置
  ///
  /// 将设置保存到持久化存储
  Future<void> saveSettings(SettingsState settings);

  /// 保存主题模式
  Future<void> saveThemeMode(ThemeMode mode);

  /// 保存主题色
  Future<void> saveThemeColor(Color color);

  /// 保存字体缩放比例
  Future<void> saveFontScale(double scale);

  /// 保存语言设置
  Future<void> saveLanguage(String? languageCode);

  /// 重置为默认设置
  Future<void> resetSettings();
}
