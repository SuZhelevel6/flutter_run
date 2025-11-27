import 'core/app/fx_application.dart';
import 'core/di/injection.dart';
import 'core/logging/talker_config.dart';
import 'core/platform/platform_adapter.dart';

/// Flutter Run - 主入口
///
/// 这是一个基于 Clean Architecture 的 Flutter 应用
///
/// 启动流程:
/// 1. 打印平台信息 (调试用)
/// 2. 初始化 Talker 日志系统
/// 3. 初始化依赖注入容器 (GetIt) - 内部会确保 WidgetsBinding 初始化
/// 4. FxApplication.run() 启动应用 (FxStarter 框架管理)
/// 5. 显示启动页面（Splash）
/// 6. FlutterRunStartRepository.initApp() 执行启动任务:
///    - 初始化窗口管理器（桌面端）
///    - 加载应用配置
/// 7. onLoaded() 回调 - 配置 BLoC 观察器
/// 8. onStartSuccess() 回调 - 导航到首页
/// 9. 完成启动，显示主应用
///
/// 注意: WidgetsFlutterBinding.ensureInitialized() 在 setupDependencies() 中调用，
/// 这样可以在同一个 zone 中完成初始化，避免 FxStarter 的 runZonedGuarded
/// 导致的 Zone mismatch 警告。
void main(List<String> args) async {
  // 打印平台信息 (用于调试)
  PlatformAdapter.printPlatformInfo();

  // 第1步：初始化 Talker 日志系统
  // 根据 Talker 官方文档：应在 main() 函数早期初始化以捕获启动期间的异常
  TalkerConfig.init();

  // 第2步：初始化依赖注入容器
  // 必须在 FxApplication.run() 之前完成，因为 AppRouter 需要访问 getIt
  // 注意: setupDependencies() 内部会确保 WidgetsBinding 初始化
  await setupDependencies();

  const FxApplication().run(args);
}
