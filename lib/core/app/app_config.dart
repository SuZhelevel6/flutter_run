import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// AppConfig: 应用配置模型
///
/// 管理应用的全局配置，如主题、语言等
/// 在启动时加载，通过 FxStarter 框架传递给应用
class AppConfig extends Equatable {
  /// 主题模式
  final ThemeMode themeMode;

  /// 是否首次启动
  final bool isFirstLaunch;

  /// 应用版本
  final String appVersion;

  const AppConfig({
    this.themeMode = ThemeMode.system,
    this.isFirstLaunch = true,
    this.appVersion = '1.0.0',
  });

  /// 创建默认配置
  factory AppConfig.defaultConfig() {
    return const AppConfig(
      themeMode: ThemeMode.system,
      isFirstLaunch: true,
      appVersion: '1.0.0',
    );
  }

  /// 复制并更新配置
  AppConfig copyWith({
    ThemeMode? themeMode,
    bool? isFirstLaunch,
    String? appVersion,
  }) {
    return AppConfig(
      themeMode: themeMode ?? this.themeMode,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  List<Object?> get props => [themeMode, isFirstLaunch, appVersion];

  @override
  String toString() {
    return 'AppConfig('
        'themeMode: $themeMode, '
        'isFirstLaunch: $isFirstLaunch, '
        'appVersion: $appVersion'
        ')';
  }
}
