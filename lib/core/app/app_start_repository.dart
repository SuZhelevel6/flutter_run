import 'package:flutter/material.dart';
import 'package:fx_boot_starter/fx_boot_starter.dart';
import 'package:window_manager/window_manager.dart';

import 'app_config.dart';
import '../platform/platform_adapter.dart';
import '../logging/app_logger.dart';

/// FlutterRunStartRepository: 启动数据仓库
///
/// 实现 AppStartRepository 接口，负责执行应用启动时的异步任务
/// 参考 FlutterUnit 的实现:
/// - 初始化 Flutter Widgets Binding
/// - 初始化窗口管理器（桌面端）
/// - 初始化日志系统
/// - 加载应用配置
class FlutterRunStartRepository implements AppStartRepository<AppConfig> {
  const FlutterRunStartRepository();

  @override
  Future<AppConfig> initApp() async {
    AppLogger.info('=== Flutter Run 启动流程 ===');
    AppLogger.info('initApp() 开始执行');
    AppLogger.info('注: WidgetsBinding 和依赖注入已在 main() 中初始化');

    // 第 1 层: 桌面端窗口初始化
    if (PlatformAdapter.isDesktop) {
      await _initWindowManager();
      AppLogger.info('1. 窗口管理器初始化完成');
    }

    // 第 2 层: 关键路径的异步任务
    // 模拟加载应用配置 (未来可以从 SharedPreferences 读取)
    AppLogger.debug('2. 开始加载应用配置...');
    await Future.delayed(const Duration(milliseconds: 300));

    final config = AppConfig.defaultConfig();
    AppLogger.info('3. 应用配置加载完成: $config');

    // 第 3 层: 网络客户端已通过依赖注入初始化
    AppLogger.debug('4. 网络客户端已就绪 (通过 GetIt 管理)');

    AppLogger.info('=== 启动数据准备完成 ===');

    // 返回应用配置
    return config;
  }

  /// 初始化窗口管理器
  Future<void> _initWindowManager() async {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      // 隐藏原生标题栏
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
