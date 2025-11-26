import 'package:flutter/material.dart';
import 'widget_showcase_page.dart';

/// Widget 展示页
///
/// 展示各种 Flutter Widget 的示例和用法
/// 入口页面，直接展示 WidgetShowcasePage
class WidgetPage extends StatelessWidget {
  const WidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 直接返回 WidgetShowcasePage
    return const WidgetShowcasePage();
  }
}
