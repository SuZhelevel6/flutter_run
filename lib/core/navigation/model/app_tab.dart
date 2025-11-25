import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';

/// 应用导航标签枚举
///
/// 定义导航栏的所有菜单项
/// 参考 FlutterUnit: lib/src/navigation/model/app_tab.dart
enum AppTab {
  widget('/widget', Icons.widgets_outlined),
  blog('/blog', Icons.article_outlined),
  painter('/painter', Icons.brush_outlined),
  knowledge('/knowledge', Icons.school_outlined),
  tools('/tools', Icons.build_outlined),
  account('/account', Icons.person_outlined);

  final String path;
  final IconData icon;

  const AppTab(this.path, this.icon);

  /// 获取国际化标签
  String label(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AppTab.widget:
        return l10n.navWidget;
      case AppTab.blog:
        return l10n.navBlog;
      case AppTab.painter:
        return l10n.navPainter;
      case AppTab.knowledge:
        return l10n.navKnowledge;
      case AppTab.tools:
        return l10n.navTools;
      case AppTab.account:
        return l10n.navAccount;
    }
  }
}
