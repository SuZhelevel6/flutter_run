import 'core/app/fx_application.dart';
import 'core/logging/talker_config.dart';
import 'core/platform/platform_adapter.dart';

/// Flutter Run - 主入口
///
/// 这是一个基于 Clean Architecture 的 Flutter 应用
///
/// 启动流程（通过 FxStarter 框架管理）:
/// 1. FxApplication.run() 启动应用
/// 2. 显示启动页面（Splash）
/// 3. FlutterRunStartRepository.initApp() 执行启动任务:
///    - 初始化 Flutter Widgets Binding
///    - 初始化 Talker 日志系统
///    - 初始化窗口管理器（桌面端）
///    - 打印平台信息
///    - 加载应用配置
/// 4. onLoaded() 回调 - 配置 BLoC 观察器
/// 5. onStartSuccess() 回调 - 导航到首页
/// 6. 完成启动，显示主应用
void main(List<String> args) {

  // 打印平台信息 (用于调试)
  PlatformAdapter.printPlatformInfo();

  // 第1步：初始化 Talker 日志系统（必须在最早期完成）
  // 根据 Talker 官方文档：应在 main() 函数早期初始化以捕获启动期间的异常
  TalkerConfig.init();

  const FxApplication().run(args);
}
