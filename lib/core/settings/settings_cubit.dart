import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logging/app_logger.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import 'settings_state.dart';

/// 设置管理 Cubit
///
/// 管理应用的所有设置项，包括：
/// - 主题模式（亮色/暗色/跟随系统）
/// - 主题色
/// - 字体大小
/// - 语言设置
///
/// 通过 SettingsRepository 进行持久化，实现业务逻辑与存储逻辑的解耦
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  /// 构造函数
  ///
  /// 通过依赖注入传入 SettingsRepository
  SettingsCubit(this._repository) : super(const SettingsState());

  /// 初始化设置（从本地存储加载）
  Future<void> init() async {
    final loadedState = await _repository.loadSettings();
    emit(loadedState);
  }

  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    AppLogger.info('主题模式切换: ${mode.name}');
    emit(state.copyWith(themeMode: mode));
    await _repository.saveSettings(state);
  }

  /// 设置主题色
  Future<void> setThemeColor(Color color) async {
    AppLogger.info('主题色切换: #${color.toARGB32().toRadixString(16).padLeft(8, '0')}');
    emit(state.copyWith(themeColor: color));
    await _repository.saveSettings(state);
  }

  /// 设置字体缩放比例
  Future<void> setFontScale(double scale) async {
    AppLogger.info('字体缩放比例设置: $scale');
    emit(state.copyWith(fontScale: scale));
    await _repository.saveSettings(state);
  }

  /// 设置语言
  Future<void> setLanguage(String? languageCode) async {
    AppLogger.info('语言设置: ${languageCode ?? "跟随系统"}');
    emit(state.copyWith(languageCode: languageCode));
    await _repository.saveSettings(state);
  }

  /// 重置为默认设置
  Future<void> reset() async {
    AppLogger.info('重置为默认设置');
    emit(const SettingsState());
    await _repository.resetSettings();
  }
}
