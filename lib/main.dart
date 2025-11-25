import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'core/logging/talker_config.dart';
import 'core/logging/app_bloc_observer.dart';
import 'core/platform/platform_adapter.dart';
import 'core/router/app_router.dart';

/// Flutter Run - 主入口
///
/// 这是一个基于 Clean Architecture 的 Flutter 应用
///
/// 启动流程:
/// 1. 初始化 Flutter Widgets Binding
/// 2. 初始化窗口管理器（桌面端）
/// 3. 初始化 Talker 日志系统
/// 4. 配置 BLoC 观察器
/// 5. 打印平台信息（开发环境）
/// 6. 启动应用
void main() async {
  // 1. 确保 Flutter Widgets Binding 已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 初始化窗口管理器（仅桌面平台）
  if (PlatformAdapter.isDesktop) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // 隐藏原生标题栏
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // 3. 初始化日志系统
  TalkerConfig.init();

  // 4. 配置 BLoC 观察器
  Bloc.observer = AppBlocObserver();

  // 5. 打印平台信息（开发环境）
  PlatformAdapter.printPlatformInfo();

  // 6. 启动应用
  runApp(const MyApp());
}

/// 应用根 Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 创建路由实例
    final router = AppRouter.createRouter();

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
