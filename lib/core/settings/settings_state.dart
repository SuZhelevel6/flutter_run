import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// 应用设置状态
///
/// 包含所有可配置的应用设置项
class SettingsState extends Equatable {
  /// 主题模式
  final ThemeMode themeMode;

  /// 主题色（种子颜色）
  final Color themeColor;

  /// 字体缩放比例
  final double fontScale;

  /// 语言代码
  final String? languageCode;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.themeColor = Colors.deepPurple,
    this.fontScale = 1.0,
    this.languageCode,
  });

  /// 创建副本
  SettingsState copyWith({
    ThemeMode? themeMode,
    Color? themeColor,
    double? fontScale,
    String? languageCode,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
      fontScale: fontScale ?? this.fontScale,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        themeColor,
        fontScale,
        languageCode,
      ];

  /// 序列化为 Map
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'themeColor': themeColor.toARGB32(),
      'fontScale': fontScale,
      'languageCode': languageCode,
    };
  }

  /// 从 Map 反序列化
  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
      themeColor: Color(json['themeColor'] as int? ?? Colors.deepPurple.toARGB32()),
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      languageCode: json['languageCode'] as String?,
    );
  }
}
