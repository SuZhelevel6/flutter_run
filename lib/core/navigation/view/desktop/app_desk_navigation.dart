import 'package:flutter/material.dart';
import 'desk_navigation_rail.dart';
import 'window_buttons.dart';

/// 桌面端应用导航框架
///
/// 通过 GoRouter 的 ShellRoute 实现外壳容器
/// 提供左右分栏布局：
/// - 左侧：DeskNavigationRail - 导航栏（常驻）
/// - 右侧：content - 由路由传入的页面内容（动态切换）
class AppDeskNavigation extends StatelessWidget {
  final Widget content;

  const AppDeskNavigation({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // 左侧导航栏：固定宽度 140，支持拖拽移动窗口
              const DragToMoveWrapper(child: DeskNavigationRail()),
              // 右侧内容区域：占据剩余空间
              Expanded(child: content),
            ],
          ),
          // 右上角窗口控制按钮
          const Positioned(
            top: 8,
            right: 8,
            child: WindowButtons(),
          ),
        ],
      ),
    );
  }
}
