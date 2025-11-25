import 'package:flutter/material.dart';
import 'dart:io';

/// 窗口控制按钮组件
///
/// 提供最小化、最大化、关闭按钮
/// 仅在桌面平台显示
class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // 仅在桌面平台显示
    if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.minimize, size: 16),
            iconSize: 16,
            onPressed: () {
              // TODO: 实现最小化窗口
              debugPrint('Minimize window');
            },
            tooltip: '最小化',
          ),
          IconButton(
            icon: const Icon(Icons.crop_square, size: 16),
            iconSize: 16,
            onPressed: () {
              // TODO: 实现最大化/还原窗口
              debugPrint('Maximize/Restore window');
            },
            tooltip: '最大化',
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            iconSize: 16,
            onPressed: () {
              // TODO: 实现关闭窗口
              debugPrint('Close window');
            },
            tooltip: '关闭',
          ),
        ],
      ),
    );
  }
}

/// 拖拽移动窗口包装器
///
/// 允许通过拖拽组件来移动窗口
class DragToMoveWrapper extends StatelessWidget {
  final Widget child;

  const DragToMoveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) {
        // TODO: 实现窗口拖拽
        debugPrint('Start dragging window');
      },
      child: child,
    );
  }
}
