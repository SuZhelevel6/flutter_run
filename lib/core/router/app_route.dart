/// 应用路由枚举
///
/// 定义所有路由的 path 和 url
/// 参考 FlutterUnit 的路由设计
enum AppRoute {
  /// Splash 启动页
  splash('/', url: '/'),

  /// 组件集录-展示页
  widget('/widget', url: '/widget'),

  /// 博客文章页
  blog('/blog', url: '/blog'),

  /// 绘制集录页
  painter('/painter', url: '/painter'),

  /// 会议工作台页
  workspace('/workspace', url: '/workspace'),

  /// 工具宝箱页
  tools('/tools', url: '/tools'),

  /// 应用信息页
  account('/account', url: '/account'),

  /// Settings 设置页
  settings('/settings', url: '/settings'),

  /// 设置子页面 - 主题模式
  settingsThemeMode('theme_mode', url: '/settings/theme_mode'),

  /// 设置子页面 - 主题色
  settingsThemeColor('theme_color', url: '/settings/theme_color'),

  /// 设置子页面 - 字体设置
  settingsFont('font', url: '/settings/font'),

  /// 设置子页面 - 语言设置
  settingsLanguage('language', url: '/settings/language'),

  /// 设置子页面 - 版本信息
  settingsVersion('version', url: '/settings/version'),

  /// 设置子页面 - 日志查看器
  settingsLogs('logs', url: '/settings/logs'),
  ;

  /// 路由路径 (用于 GoRoute 的 path 参数)
  final String path;

  /// 路由 URL (用于导航，如 context.go(AppRoute.widget.url))
  final String url;

  const AppRoute(
    this.path, {
    required this.url,
  });
}
