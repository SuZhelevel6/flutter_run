import 'package:flutter/material.dart';

/// 应用导航标签枚举
///
/// 定义导航栏的所有菜单项
/// 参考 FlutterUnit: lib/src/navigation/model/app_tab.dart
enum AppTab {
  widget('/widget', Icons.widgets_outlined, 'Widget'),
  blog('/blog', Icons.article_outlined, 'Blog'),
  painter('/painter', Icons.brush_outlined, 'Painter'),
  knowledge('/knowledge', Icons.school_outlined, 'Knowledge'),
  tools('/tools', Icons.build_outlined, 'Tools'),
  account('/account', Icons.person_outlined, 'Account');

  final String path;
  final IconData icon;
  final String label;

  const AppTab(this.path, this.icon, this.label);
}
