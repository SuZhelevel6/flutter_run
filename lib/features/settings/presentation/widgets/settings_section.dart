import 'package:flutter/material.dart';

/// 设置分组容器组件
///
/// 提供统一的圆角卡片样式，用于包裹一组相关的设置项
/// 支持可选的标题显示
class SettingsSection extends StatelessWidget {
  /// 分组标题（可选）
  final String? title;

  /// 子组件列表
  final List<Widget> children;

  /// 外边距
  final EdgeInsetsGeometry margin;

  const SettingsSection({
    super.key,
    this.title,
    required this.children,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.only(
              left: margin.horizontal / 2,
              bottom: 6,
            ),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ],
        Padding(
          padding: margin,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: _buildChildrenWithDividers(),
            ),
          ),
        ),
      ],
    );
  }

  /// 在子组件之间插入分割线
  List<Widget> _buildChildrenWithDividers() {
    if (children.isEmpty) return [];

    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(const Divider(height: 1, indent: 16, endIndent: 16));
      }
    }
    return result;
  }
}
