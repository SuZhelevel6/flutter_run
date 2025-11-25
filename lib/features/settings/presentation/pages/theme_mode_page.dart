import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';

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

    return BlocBuilder<SettingsCubit, dynamic>(
      builder: (context, state) {
        final settings = context.watch<SettingsCubit>().state;
        final currentMode = settings.themeMode;

        return Scaffold(
          appBar: AppBar(
            title: const Text('深色模式'),
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
                    title: const Text(
                      '跟随系统',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      '自动根据系统设置切换主题',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: currentMode == ThemeMode.system,
                    activeColor: themeColor,
                    onChanged: (bool value) {
                      final newMode =
                          value ? ThemeMode.system : ThemeMode.light;
                      context.read<SettingsCubit>().setThemeMode(newMode);
                      _showSnackBar(
                          context, value ? '已启用跟随系统' : '已关闭跟随系统');
                    },
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 6),
                child: Text(
                  '手动设置',
                  style: TextStyle(
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
                            _showSnackBar(context, '已切换到浅色模式');
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
                                const Expanded(
                                  child: Text('浅色模式'),
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
                            _showSnackBar(context, '已切换到深色模式');
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
                                const Expanded(
                                  child: Text('深色模式'),
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
