import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/l10n/l10n.dart';

/// 设置页面
///
/// 参考 FlutterPlay 的设置页面设计
/// 提供应用的各项配置功能
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
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
                  themeModeLabel = l10n.followSystem;
                  break;
                case ThemeMode.light:
                  themeModeLabel = l10n.lightMode;
                  break;
                case ThemeMode.dark:
                  themeModeLabel = l10n.darkModeOption;
                  break;
              }

              return _SettingItem(
                icon: Icons.dark_mode,
                title: l10n.darkMode,
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
                title: l10n.themeColor,
                subtitle: l10n.currentThemeColor,
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
                title: l10n.fontSettings,
                subtitle: '${l10n.fontScale} $fontScalePercent%',
                onTap: () {
                  context.push(AppRoute.settingsFont.url);
                },
              );
            },
          ),

          const SizedBox(height: 12),

          // 语言设置
          BlocBuilder<SettingsCubit, dynamic>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              // 如果为 null 或 'zh'，显示中文；否则显示英文
              String languageLabel = (settings.languageCode == 'en')
                  ? l10n.languageEnglish
                  : l10n.languageSimplifiedChinese;

              return _SettingItem(
                icon: Icons.translate,
                title: l10n.languageSettings,
                subtitle: languageLabel,
                onTap: () {
                  context.push(AppRoute.settingsLanguage.url);
                },
              );
            },
          ),

          const SizedBox(height: 12),

          // 版本信息
          _SettingItem(
            icon: Icons.info_outline,
            title: l10n.versionInfo,
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
              title: l10n.logViewer,
              subtitle: l10n.logViewerSubtitle,
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
