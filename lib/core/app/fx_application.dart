import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_run/core/logging/app_logger.dart';
import 'package:fx_boot_starter/fx_boot_starter.dart';

import 'app_config.dart';
import 'app_start_repository.dart';
import '../router/app_router.dart';
import '../logging/app_bloc_observer.dart';

/// FxApplication: 应用启动器
///
/// 混入 FxStarter 框架，负责整个应用的启动生命周期管理
/// 参考 FlutterUnit: lib/src/starter/fx_application.dart
///
/// 启动流程:
/// 1. main() 调用 run()
/// 2. 显示带 AppStartListener 的 Splash 页面
/// 3. 执行 repository.initApp() 加载数据
/// 4. 触发 onLoaded() 回调
/// 5. 触发 onStartSuccess() 回调
/// 6. 自动切换到主应用
class FxApplication with FxStarter<AppConfig> {
  const FxApplication();

  /// 必须实现: 根 Widget
  /// 返回一个使用 GoRouter 的 MaterialApp.router
  @override
  Widget get app => AppRouter.createRouterApp();

  /// 必须实现: 启动数据仓库
  /// 负责执行启动时的异步任务
  @override
  AppStartRepository<AppConfig> get repository =>
      const FlutterRunStartRepository();

  /// 生命周期钩子 1: 数据加载完成
  ///
  /// 在 repository.initApp() 执行完成后调用
  /// 此时启动数据已准备好，可以初始化 Bloc 等状态管理
  ///
  /// 参数:
  /// - context: BuildContext
  /// - cost: 启动耗时(毫秒)
  /// - state: 加载的应用配置
  @override
  void onLoaded(BuildContext context, int cost, AppConfig state) async {
    AppLogger.info('=== onLoaded 回调 ===');
    AppLogger.info('启动耗时: $cost ms');
    AppLogger.info('应用配置: $state');

    // 配置 BLoC 观察器
    Bloc.observer = AppBlocObserver();
    AppLogger.info('BLoC 观察器已配置');

    // 这里可以初始化全局 Bloc
    // 例如: context.read<AppConfigBloc>().init(state);

    // 延迟非关键数据加载
    // 例如:
    // - 加载用户收藏数据
    // - 加载分类数据
    // - 加载新闻数据
    AppLogger.debug('延迟加载非关键数据...');
  }

  /// 生命周期钩子 2: 启动成功
  ///
  /// 在 onLoaded 之后调用
  /// 此时可以执行检查更新等操作
  ///
  /// 注意: 不要在此处使用 context.go() 导航，因为此时 GoRouter 还未就绪
  /// FlutterRunSplash 会监听启动状态，在成功后自动跳转到首页
  ///
  /// 参数:
  /// - context: BuildContext
  /// - state: 应用配置
  @override
  void onStartSuccess(BuildContext context, AppConfig state) {
    AppLogger.info('=== onStartSuccess 回调 ===');
    AppLogger.info('启动成功，应用已就绪!');
    AppLogger.info('FlutterRunSplash 将在延迟后自动跳转到首页');
    AppLogger.info('GoRouter 初始路由: / (Splash)');
    AppLogger.info('应用启动流程完成');
  }

  /// 生命周期钩子 3: 启动失败
  ///
  /// 在启动过程中发生错误时调用
  ///
  /// 参数:
  /// - context: BuildContext
  /// - error: 错误对象
  /// - trace: 堆栈跟踪
  @override
  void onStartError(BuildContext context, Object error, StackTrace trace) {
    AppLogger.error('=== onStartError 回调 ===');
    AppLogger.error('启动失败: $error');
    AppLogger.error('堆栈跟踪: $trace');

    // TODO: 可以在这里显示错误页面或重试按钮
    // 注意: 不要使用 context.go() 导航，因为 GoRouter 可能还未就绪
  }

  /// 生命周期钩子 4: 全局错误处理
  ///
  /// 处理应用运行时的全局错误
  ///
  /// 参数:
  /// - error: 错误对象
  /// - stack: 堆栈跟踪
  @override
  void onGlobalError(Object error, StackTrace stack) {
    AppLogger.error('=== onGlobalError 回调 ===');
    AppLogger.error('全局错误: $error');
    AppLogger.error('堆栈跟踪: $stack');

    // 这里可以:
    // 1. 上报错误到日志平台
    // 2. 显示错误提示
    // 3. 记录错误日志
  }
}
