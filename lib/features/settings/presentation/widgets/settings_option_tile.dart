import 'package:flutter/material.dart';

/// 设置选项行组件
///
/// 用于显示单选/多选设置项，带有标题和选中状态指示
/// 统一的点击效果和布局样式
class SettingsOptionTile extends StatelessWidget {
  /// 选项标题
  final String title;

  /// 是否选中
  final bool isSelected;

  /// 点击回调
  final VoidCallback onTap;

  /// 选中图标颜色（默认使用主题色）
  final Color? checkColor;

  const SettingsOptionTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.checkColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCheckColor = checkColor ?? Theme.of(context).primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(title),
            ),
            if (isSelected)
              Icon(Icons.check, size: 20, color: effectiveCheckColor),
          ],
        ),
      ),
      ),
    );
  }
}
