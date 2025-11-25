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

    // 根据路径确定当前选中的索引
    int selectedIndex = 0;
    for (int i = 0; i < AppTab.values.length; i++) {
      if (location.startsWith(AppTab.values[i].path)) {
        selectedIndex = i;
        break;
      }
    }

    return Container(
      width: 140,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
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

          // 导航栏
          Expanded(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              labelType: NavigationRailLabelType.all,
              destinations: AppTab.values
                  .map(
                    (tab) => NavigationRailDestination(
                      icon: Icon(tab.icon),
                      label: Text(tab.label),
                    ),
                  )
                  .toList(),
              onDestinationSelected: (index) {
                final tab = AppTab.values[index];
                context.go(tab.path);
              },
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
