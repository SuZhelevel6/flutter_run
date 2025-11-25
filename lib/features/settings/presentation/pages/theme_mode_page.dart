import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/l10n/l10n.dart';

/// 深色模式设置页面
///
/// 参考 FlutterPlay: ThemeModePage
/// 提供三种主题模式选择:
/// - 跟随系统（Switch 开关）
/// - 浅色模式（单选）
/// - 深色模式（单选）
class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final l10n = context.l10n;

    return BlocBuilder<SettingsCubit, dynamic>(
      builder: (context, state) {
        final settings = context.watch<SettingsCubit>().state;
        final currentMode = settings.themeMode;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.themeModeTitle),
          ),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // 跟随系统开关
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SwitchListTile(
                    title: Text(
                      l10n.followSystem,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      l10n.followSystemDesc,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: currentMode == ThemeMode.system,
                    activeColor: themeColor.withAlpha(128),
                    activeTrackColor: themeColor,
                    onChanged: (bool value) {
                      final newMode =
                          value ? ThemeMode.system : ThemeMode.light;
                      context.read<SettingsCubit>().setThemeMode(newMode);
                      _showSnackBar(
                          context, value ? l10n.followSystemEnabled : l10n.followSystemDisabled);
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 6),
                child: Text(
                  l10n.manualSettings,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),

              // 手动设置容器
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      // 浅色模式
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<SettingsCubit>()
                                .setThemeMode(ThemeMode.light);
                            _showSnackBar(context, l10n.lightModeEnabled);
                          },
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
                                  child: Text(l10n.lightMode),
                                ),
                                if (currentMode == ThemeMode.light)
                                  Icon(Icons.check, size: 20, color: themeColor),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Divider(height: 1, indent: 16, endIndent: 16),

                      // 深色模式
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<SettingsCubit>()
                                .setThemeMode(ThemeMode.dark);
                            _showSnackBar(context, l10n.darkModeEnabled);
                          },
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
                                  child: Text(l10n.darkModeOption),
                                ),
                                if (currentMode == ThemeMode.dark)
                                  Icon(Icons.check, size: 20, color: themeColor),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
