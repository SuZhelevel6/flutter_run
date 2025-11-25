import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_route.dart';

/// Settings 设置页
///
/// 应用设置和配置
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('主题模式'),
            subtitle: const Text('亮色/暗色/跟随系统'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(AppRoute.settingsThemeMode.url),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('主题色'),
            subtitle: const Text('选择应用主题颜色'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(AppRoute.settingsThemeColor.url),
          ),
          ListTile(
            leading: const Icon(Icons.font_download_outlined),
            title: const Text('字体设置'),
            subtitle: const Text('调整字体大小'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(AppRoute.settingsFont.url),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('语言设置'),
            subtitle: const Text('中文/English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(AppRoute.settingsLanguage.url),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('版本信息'),
            subtitle: const Text('查看应用版本'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(AppRoute.settingsVersion.url),
          ),
        ],
      ),
    );
  }
}
