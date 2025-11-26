import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_route.dart';
import '../../../settings/settings_cubit.dart';
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/app_icon.png',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter Run',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          // 分割线（应用名与菜单项之间）
          Divider(
            color: isDark ? Colors.white24 : Colors.black12,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 8),

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
                  context: context,
                );
              }).toList(),
            ),
          ),

          // 底部操作按钮区域（参考 FlutterPlay MenuBarTail）
          Divider(
            color: isDark ? Colors.white24 : Colors.black12,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 8),
          const _MenuBarTail(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// 导航栏底部操作按钮组
///
/// 参考 FlutterPlay MenuBarTail 设计
/// 包含：设置、语言切换、深色模式切换
class _MenuBarTail extends StatelessWidget {
  const _MenuBarTail();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 设置按钮
          _ActionButton(
            icon: Icons.settings,
            onTap: () {
              context.go(AppRoute.settings.url);
            },
          ),
          // 语言切换按钮（中英文切换）
          BlocBuilder<SettingsCubit, dynamic>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              return _ActionButton(
                icon: Icons.translate,
                onTap: () {
                  // 在中英文之间切换
                  // 如果是英文或 null，切换到中文；如果是中文，切换到英文
                  final newLanguage = (settings.languageCode == 'zh') ? 'en' : 'zh';
                  context.read<SettingsCubit>().setLanguage(newLanguage);
                },
              );
            },
          ),
          // 深色模式切换按钮
          BlocBuilder<SettingsCubit, dynamic>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              // 根据当前主题显示不同图标
              final icon = settings.themeMode == ThemeMode.dark
                  ? Icons.light_mode  // 深色模式显示太阳图标
                  : Icons.dark_mode;  // 浅色模式显示月亮图标

              return _ActionButton(
                icon: icon,
                onTap: () {
                  // 在深色和浅色模式之间切换
                  final newMode = settings.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                  context.read<SettingsCubit>().setThemeMode(newMode);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 操作按钮（带悬停效果）
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // 根据主题模式调整按钮颜色
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hoverColor = isDark ? Colors.white24 : Colors.black12;
    final iconColor = isDark ? Colors.white : Colors.black87;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _isHovered ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            color: iconColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// 菜单项单元格
class _MenuCell extends StatelessWidget {
  final AppTab tab;
  final bool isSelected;
  final VoidCallback onTap;
  final BuildContext context;

  const _MenuCell({
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.context,
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
                  tab.label(context),
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
