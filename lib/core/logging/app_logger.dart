import 'package:flutter/foundation.dart';
import 'talker_config.dart';

/// 应用日志服务封装
///
/// 提供简洁的日志记录 API，封装 Talker 的使用细节
/// 推荐在代码中使用此类，而不是直接使用 Talker 实例
///
/// 使用示例：
/// ```dart
/// // 记录信息日志
/// AppLogger.info('用户登录成功');
///
/// // 记录警告
/// AppLogger.warning('缓存即将过期');
///
/// // 记录错误
/// AppLogger.error('网络请求失败', error, stackTrace);
///
/// // 记录调试信息
/// AppLogger.debug('当前状态: $state');
/// ```
class AppLogger {
  // 私有构造函数，防止实例化
  AppLogger._();

  /// 记录详细日志（开发环境）
  ///
  /// 用于记录详细的调试信息
  /// 仅在开发模式下输出
  ///
  /// [message] 日志消息
  static void verbose(String message) {
    if (kDebugMode) {
      TalkerConfig.talker.verbose(message);
    }
  }

  /// 记录调试日志
  ///
  /// 用于记录开发调试信息
  /// 仅在开发模式下输出
  ///
  /// [message] 日志消息
  static void debug(String message) {
    if (kDebugMode) {
      TalkerConfig.talker.debug(message);
    }
  }

  /// 记录信息日志
  ///
  /// 用于记录一般性信息
  /// 开发和生产环境都会记录到历史，但只在开发环境输出到控制台
  ///
  /// [message] 日志消息
  static void info(String message) {
    TalkerConfig.talker.info(message);
  }

  /// 记录警告日志
  ///
  /// 用于记录需要注意但不影响功能的问题
  /// 开发和生产环境都会记录
  ///
  /// [message] 警告消息
  /// [error] 可选的错误对象
  /// [stackTrace] 可选的堆栈跟踪
  static void warning(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (error != null || stackTrace != null) {
      TalkerConfig.talker.warning(message, error, stackTrace);
    } else {
      TalkerConfig.talker.warning(message);
    }
  }

  /// 记录错误日志
  ///
  /// 用于记录错误信息
  /// 开发和生产环境都会记录
  ///
  /// [message] 错误消息
  /// [error] 可选的错误对象
  /// [stackTrace] 可选的堆栈跟踪
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (error != null || stackTrace != null) {
      TalkerConfig.talker.error(message, error, stackTrace);
    } else {
      TalkerConfig.talker.error(message);
    }
  }

  /// 记录严重错误日志
  ///
  /// 用于记录可能导致应用崩溃的严重错误
  /// 开发和生产环境都会记录
  ///
  /// [message] 错误消息
  /// [error] 可选的错误对象
  /// [stackTrace] 可选的堆栈跟踪
  static void critical(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (error != null || stackTrace != null) {
      TalkerConfig.talker.critical(message, error, stackTrace);
    } else {
      TalkerConfig.talker.critical(message);
    }
  }

  /// 记录网络请求日志
  ///
  /// [method] HTTP 方法（GET、POST 等）
  /// [url] 请求 URL
  /// [statusCode] 响应状态码
  /// [duration] 请求耗时
  static void logRequest(
    String method,
    String url, {
    int? statusCode,
    Duration? duration,
  }) {
    final buffer = StringBuffer();
    buffer.write('$method $url');

    if (statusCode != null) {
      buffer.write(' - $statusCode');
    }

    if (duration != null) {
      buffer.write(' (${duration.inMilliseconds}ms)');
    }

    info(buffer.toString());
  }

  /// 记录 BLoC 事件日志
  ///
  /// [blocName] BLoC 名称
  /// [event] 事件对象
  static void logBlocEvent(String blocName, Object event) {
    if (kDebugMode) {
      debug('[$blocName] Event: ${event.runtimeType}');
    }
  }

  /// 记录 BLoC 状态变化日志
  ///
  /// [blocName] BLoC 名称
  /// [currentState] 当前状态
  /// [nextState] 下一个状态
  static void logBlocTransition(
    String blocName,
    Object currentState,
    Object nextState,
  ) {
    if (kDebugMode) {
      debug(
        '[$blocName] Transition: ${currentState.runtimeType} -> ${nextState.runtimeType}',
      );
    }
  }

  /// 记录性能指标
  ///
  /// [name] 指标名称
  /// [duration] 耗时
  /// [extra] 额外信息
  static void logPerformance(
    String name,
    Duration duration, {
    Map<String, dynamic>? extra,
  }) {
    final buffer = StringBuffer();
    buffer.write('⏱️ $name: ${duration.inMilliseconds}ms');

    if (extra != null && extra.isNotEmpty) {
      buffer.write(' | $extra');
    }

    info(buffer.toString());
  }

  /// 记录用户行为
  ///
  /// [action] 用户行为描述
  /// [params] 行为参数
  static void logUserAction(String action, [Map<String, dynamic>? params]) {
    final buffer = StringBuffer();
    buffer.write('👤 User Action: $action');

    if (params != null && params.isNotEmpty) {
      buffer.write(' | $params');
    }

    info(buffer.toString());
  }

  /// 记录导航事件
  ///
  /// [from] 来源页面
  /// [to] 目标页面
  static void logNavigation(String from, String to) {
    info('📍 Navigation: $from -> $to');
  }
}
