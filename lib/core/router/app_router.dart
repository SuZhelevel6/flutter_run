import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import '../platform/platform_adapter.dart';
import '../navigation/view/desktop/app_desk_navigation.dart';
import '../app/splash/splash_page.dart';
import '../settings/settings_cubit.dart';
import '../l10n/l10n.dart';
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
import '../../features/settings/presentation/pages/log_viewer_page.dart';

/// AppRouter: 应用路由配置
///
/// 使用 ShellRoute 实现导航栏外壳
class AppRouter {
  /// 主体路由列表
  static List<RouteBase> get _bodyRoutes => [
        // Splash 启动页（独立路由，不在导航栏外壳内）
        GoRoute(
          path: '/',
          builder: (context, state) => const FlutterRunSplash(),
        ),
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
            // 日志查看器
            GoRoute(
              path: 'logs',
              builder: (context, state) => const LogViewerPage(),
            ),
          ],
        ),
      ];

  /// 创建 GoRouter 实例
  static GoRouter createRouter() {
    // Splash 路由（独立，不在 ShellRoute 内）
    final splashRoute = GoRoute(
      path: '/',
      builder: (context, state) => const FlutterRunSplash(),
    );

    // 主功能路由（除去 Splash）
    final mainRoutes = _bodyRoutes.where((route) {
      if (route is GoRoute) {
        return route.path != '/';
      }
      return true;
    }).toList();

    return GoRouter(
      initialLocation: '/', // 初始路由改为 Splash
      routes: <RouteBase>[
        // Splash 路由（独立）
        splashRoute,

        // 主体路由 - 根据平台判断是否使用 ShellRoute
        if (PlatformAdapter.isDesktopUI)
          ShellRoute(
            builder: (context, state, Widget child) => AppDeskNavigation(content: child),
            routes: mainRoutes,
          ),
        if (!PlatformAdapter.isDesktopUI) ...mainRoutes,
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
  /// Splash 页面通过路由显示，初始路由为 "/"
  static Widget createRouterApp() {
    final router = createRouter();

    // 创建全局的 SettingsCubit 实例
    return BlocProvider(
      create: (context) => SettingsCubit()..init(),
      child: BlocBuilder<SettingsCubit, dynamic>(
        builder: (context, settingsState) {
          // 获取设置状态
          final settings = context.watch<SettingsCubit>().state;

          // 根据语言代码确定 Locale
          Locale? locale;
          if (settings.languageCode != null) {
            locale = Locale(settings.languageCode!);
          }

          return MaterialApp.router(
            title: 'Flutter Run',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            // 国际化配置
            locale: locale,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('zh', 'CN'), // 简体中文
              Locale('en', 'US'), // 英文
            ],
            // 使用设置中的主题模式
            themeMode: settings.themeMode,
            // 亮色主题 - 使用设置中的主题色
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: settings.themeColor),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
            ),
            // 暗色主题 - 使用设置中的主题色
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: settings.themeColor,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
            ),
            // 字体缩放
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(settings.fontScale),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
