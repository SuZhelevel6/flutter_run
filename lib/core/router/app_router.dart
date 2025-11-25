import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../platform/platform_adapter.dart';
import '../navigation/view/desktop/app_desk_navigation.dart';
import '../../features/widget/presentation/pages/widget_page.dart';
import '../../features/blog/presentation/pages/blog_page.dart';
import '../../features/painter/presentation/pages/painter_page.dart';
import '../../features/knowledge/presentation/pages/knowledge_page.dart';
import '../../features/tools/presentation/pages/tools_page.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/theme_mode_page.dart';
import '../../features/settings/presentation/pages/theme_color_page.dart';
import '../../features/settings/presentation/pages/font_setting_page.dart';
import '../../features/settings/presentation/pages/language_setting_page.dart';
import '../../features/settings/presentation/pages/version_info_page.dart';

/// AppRouter: 应用路由配置
///
/// 使用 ShellRoute 实现导航栏外壳
class AppRouter {
  /// 主体路由列表
  static List<RouteBase> get _bodyRoutes => [
        GoRoute(
          path: '/widget',
          builder: (context, state) => const WidgetPage(),
        ),
        GoRoute(
          path: '/blog',
          builder: (context, state) => const BlogPage(),
        ),
        GoRoute(
          path: '/painter',
          builder: (context, state) => const PainterPage(),
        ),
        GoRoute(
          path: '/knowledge',
          builder: (context, state) => const KnowledgePage(),
        ),
        GoRoute(
          path: '/tools',
          builder: (context, state) => const ToolsPage(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
          routes: [
            // 深色模式设置
            GoRoute(
              path: 'theme_mode',
              builder: (context, state) => const ThemeModePage(),
            ),
            // 主题色设置
            GoRoute(
              path: 'theme_color',
              builder: (context, state) => const ThemeColorPage(),
            ),
            // 字体设置
            GoRoute(
              path: 'font',
              builder: (context, state) => const FontSettingPage(),
            ),
            // 语言设置
            GoRoute(
              path: 'language',
              builder: (context, state) => const LanguageSettingPage(),
            ),
            // 版本信息
            GoRoute(
              path: 'version',
              builder: (context, state) => const VersionInfoPage(),
            ),
          ],
        ),
      ];

  /// 创建 GoRouter 实例
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/widget',
      routes: <RouteBase>[
        // 主体路由 - 根据平台判断是否使用 ShellRoute
        if (PlatformAdapter.isDesktopUI)
          ShellRoute(
            builder: (context, state, Widget child) => AppDeskNavigation(content: child),
            routes: _bodyRoutes,
          ),
        if (!PlatformAdapter.isDesktopUI) ..._bodyRoutes,
      ],
      // 异常处理
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('页面不存在', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('${state.uri}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/widget'),
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 创建 MaterialApp.router 实例
  ///
  /// 用于 FxApplication，返回一个使用 GoRouter 的 MaterialApp.router
  static Widget createRouterApp() {
    final router = createRouter();

    return MaterialApp.router(
      title: 'Flutter Run',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
