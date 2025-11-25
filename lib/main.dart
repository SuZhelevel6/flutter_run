import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/logging/talker_config.dart';
import 'core/logging/app_bloc_observer.dart';
import 'core/platform/platform_adapter.dart';
import 'core/router/app_router.dart';

/// Flutter Run - 主入口
///
/// 这是一个基于 Clean Architecture 的 Flutter 应用
///
/// 启动流程:
/// 1. 初始化 Talker 日志系统
/// 2. 配置 BLoC 观察器
/// 3. 打印平台信息（开发环境）
/// 4. 启动应用
void main() {
  // 1. 初始化日志系统（必须最早）
  TalkerConfig.init();

  // 2. 配置 BLoC 观察器
  Bloc.observer = AppBlocObserver();

  // 3. 打印平台信息（开发环境）
  PlatformAdapter.printPlatformInfo();

  // 4. 启动应用
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
