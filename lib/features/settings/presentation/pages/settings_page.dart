import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/settings/settings_cubit.dart';

/// 设置页面
///
/// 参考 FlutterPlay 的设置页面设计
/// 提供应用的各项配置功能
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 深色模式 - 从 SettingsCubit 读取当前模式
          BlocBuilder<SettingsCubit, dynamic>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              String themeModeLabel;
              switch (settings.themeMode) {
                case ThemeMode.system:
                  themeModeLabel = '跟随系统';
                  break;
                case ThemeMode.light:
                  themeModeLabel = '浅色模式';
                  break;
                case ThemeMode.dark:
                  themeModeLabel = '深色模式';
                  break;
              }

              return _SettingItem(
                icon: Icons.dark_mode,
                title: '深色模式',
                subtitle: themeModeLabel,
                onTap: () {
                  context.push(AppRoute.settingsThemeMode.url);
                },
              );
            },
          ),

          const SizedBox(height: 12),

          // 主题色设置 - 从 SettingsCubit 读取当前主题色
          BlocBuilder<SettingsCubit, dynamic>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              return _SettingItem(
                icon: Icons.palette,
                title: '主题色',
                subtitle: '当前主题色',
                subtitleColor: settings.themeColor,
                onTap: () {
                  context.push(AppRoute.settingsThemeColor.url);
                },
              );
            },
          ),

          const SizedBox(height: 12),

          // 字体设置
          BlocBuilder<SettingsCubit, dynamic>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              final fontScalePercent = (settings.fontScale * 100).toInt();
              return _SettingItem(
                icon: Icons.font_download,
                title: '字体设置',
                subtitle: '字体缩放 $fontScalePercent%',
                onTap: () {
                  context.push(AppRoute.settingsFont.url);
                },
              );
            },
          ),

          const SizedBox(height: 12),

          // 语言设置
          _SettingItem(
            icon: Icons.translate,
            title: '语言设置',
            subtitle: '简体中文（功能开发中）',
            onTap: () {
              context.push(AppRoute.settingsLanguage.url);
            },
          ),

          const SizedBox(height: 12),

          // 版本信息
          _SettingItem(
            icon: Icons.info_outline,
            title: '版本信息',
            subtitle: 'v1.0.0',
            onTap: () {
              context.push(AppRoute.settingsVersion.url);
            },
          ),

          // 日志查看器（仅开发模式）
          if (kDebugMode) ...[
            const SizedBox(height: 12),
            _SettingItem(
              icon: Icons.bug_report,
              title: '日志查看器',
              subtitle: '开发模式 - 查看应用日志',
              subtitleColor: Colors.orange,
              onTap: () {
                context.push(AppRoute.settingsLogs.url);
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// 设置项组件
///
/// 显示图标、标题、副标题和右箭头
/// 独立卡片样式，带圆角和阴影
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 根据主题模式调整颜色
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 主图标：深色模式用白色，浅色模式用主题色
    final mainIconColor = isDark
        ? Colors.white
        : Theme.of(context).primaryColor;
    final arrowColor = isDark ? Colors.grey : Colors.grey.shade600;
    final defaultSubtitleColor = isDark ? Colors.grey : Colors.grey.shade700;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: mainIconColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: subtitleColor ?? defaultSubtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: arrowColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
