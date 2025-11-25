import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'talker_config.dart';
import 'app_logger.dart';

/// AppBlocObserver: 应用 BLoC 观察者
///
/// 监听所有 BLoC 的事件、状态变化和错误
/// 集成 Talker 日志记录
///
/// 参考建议文档的 BLoC 日志拦截实现
class AppBlocObserver extends BlocObserver {
  /// Talker BLoC 日志记录器（延迟初始化）
  TalkerBlocObserver? _talkerObserver;

  /// 获取 Talker 观察者（延迟创建）
  TalkerBlocObserver get talkerObserver {
    return _talkerObserver ??= TalkerBlocObserver(
      talker: TalkerConfig.talker,
      settings: const TalkerBlocLoggerSettings(
        // 是否打印事件
        printEvents: true,
        // 是否打印状态变化
        printTransitions: true,
        // 是否打印创建
        printCreations: true,
        // 是否打印关闭
        printClosings: true,
      ),
    );
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    talkerObserver.onCreate(bloc);

    if (kDebugMode) {
      debugPrint('🔷 BLoC Created: ${bloc.runtimeType}');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    talkerObserver.onEvent(bloc, event);

    if (kDebugMode && event != null) {
      AppLogger.logBlocEvent(bloc.runtimeType.toString(), event);
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    talkerObserver.onChange(bloc, change);

    // 开发环境记录详细的状态变化
    if (kDebugMode) {
      AppLogger.logBlocTransition(
        bloc.runtimeType.toString(),
        change.currentState,
        change.nextState,
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    talkerObserver.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    talkerObserver.onError(bloc, error, stackTrace);

    // 记录 BLoC 错误到日志
    AppLogger.error(
      'BLoC Error in ${bloc.runtimeType}',
      error,
      stackTrace,
    );

    // 生产环境也需要记录错误
    debugPrint('❌ BLoC Error in ${bloc.runtimeType}: $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    talkerObserver.onClose(bloc);

    if (kDebugMode) {
      debugPrint('🔶 BLoC Closed: ${bloc.runtimeType}');
    }
  }
}
