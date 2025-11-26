import 'package:flutter/material.dart';
import 'widget_category.dart';

/// Widget 信息模型
///
/// 包含组件的基本信息和元数据
class WidgetInfo {
  /// 组件名称 (如 "Container")
  final String name;

  /// 组件分类
  final WidgetCategory category;

  /// 组件描述
  final String description;

  /// 组件图标
  final IconData icon;

  /// 组件颜色 (用于卡片背景)
  final Color color;

  /// 组件示例代码
  final String? sampleCode;

  /// 组件示例 Widget
  final Widget? sampleWidget;

  const WidgetInfo({
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.color,
    this.sampleCode,
    this.sampleWidget,
  });

  /// 复制并修改部分字段
  WidgetInfo copyWith({
    String? name,
    WidgetCategory? category,
    String? description,
    IconData? icon,
    Color? color,
    String? sampleCode,
    Widget? sampleWidget,
  }) {
    return WidgetInfo(
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sampleCode: sampleCode ?? this.sampleCode,
      sampleWidget: sampleWidget ?? this.sampleWidget,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WidgetInfo &&
        other.name == name &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(name, category);
}
