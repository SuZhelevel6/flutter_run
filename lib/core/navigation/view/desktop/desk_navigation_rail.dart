import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_route.dart';
import '../../model/app_tab.dart';

/// 桌面端导航栏组件
///
/// 使用 NavigationRail 实现左侧导航
class DeskNavigationRail extends StatelessWidget {
  const DeskNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取当前路由路径
    final location = GoRouterState.of(context).uri.path;

    // 根据主题模式调整背景色
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xff2C3036)  // 深色模式：深灰色
        : const Color(0xffF5F5F5);  // 浅色模式：浅灰色

    return Container(
      width: 140,
      color: backgroundColor,
      child: Column(
        children: [
          // 顶部 Logo 区域
          const SizedBox(height: 60),
          const Icon(Icons.play_circle_filled, size: 48, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            'Flutter Run',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 24),

          // 导航菜单列表（使用 ListView 防止溢出）
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: AppTab.values.map((tab) {
                final isSelected = location.startsWith(tab.path);
                return _MenuCell(
                  tab: tab,
                  isSelected: isSelected,
                  onTap: () => context.go(tab.path),
                );
              }).toList(),
            ),
          ),

          // 底部设置按钮
          const Divider(height: 1),
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.go(AppRoute.settings.url),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// 菜单项单元格
class _MenuCell extends StatelessWidget {
  final AppTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuCell({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 根据主题模式调整颜色
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? Theme.of(context).primaryColor
        : (isDark
            ? Colors.white.withAlpha(33)  // 深色模式：半透明白色
            : Colors.black.withAlpha(26)); // 浅色模式：半透明黑色

    final iconColor = isSelected
        ? Colors.white
        : (isDark ? Colors.white70 : Colors.black54);

    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.white70 : Colors.black54);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.only(left: 12),
          height: 42,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21),
              bottomRight: Radius.circular(21),
            ),
          ),
          child: Row(
            children: [
              Icon(
                tab.icon,
                color: iconColor,
                size: isSelected ? 22 : 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tab.label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: isSelected ? 15 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
