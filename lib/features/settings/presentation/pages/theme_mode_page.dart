import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/l10n/l10n.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_option_tile.dart';

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
              _SystemModeSwitch(
                currentMode: currentMode,
                themeColor: themeColor,
                l10n: l10n,
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

              // 手动设置选项
              SettingsSection(
                children: [
                  SettingsOptionTile(
                    title: l10n.lightMode,
                    isSelected: currentMode == ThemeMode.light,
                    checkColor: themeColor,
                    onTap: () {
                      context.read<SettingsCubit>().setThemeMode(ThemeMode.light);
                      _showSnackBar(context, l10n.lightModeEnabled);
                    },
                  ),
                  SettingsOptionTile(
                    title: l10n.darkModeOption,
                    isSelected: currentMode == ThemeMode.dark,
                    checkColor: themeColor,
                    onTap: () {
                      context.read<SettingsCubit>().setThemeMode(ThemeMode.dark);
                      _showSnackBar(context, l10n.darkModeEnabled);
                    },
                  ),
                ],
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

/// 跟随系统模式开关
class _SystemModeSwitch extends StatelessWidget {
  final ThemeMode currentMode;
  final Color themeColor;
  final AppLocalizations l10n;

  const _SystemModeSwitch({
    required this.currentMode,
    required this.themeColor,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: SwitchListTile(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
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
            final newMode = value ? ThemeMode.system : ThemeMode.light;
            context.read<SettingsCubit>().setThemeMode(newMode);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value ? l10n.followSystemEnabled : l10n.followSystemDisabled,
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
