import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Talker 配置和初始化
///
/// 提供全局的 Talker 实例和配置
/// 参考建议文档的日志管理最佳实践
class TalkerConfig {
  // 私有构造函数，防止实例化
  TalkerConfig._();

  /// 全局 Talker 实例
  static late final Talker talker;

  /// 初始化 Talker
  ///
  /// 应该在应用启动时调用，例如在 main() 函数的最开始
  ///
  /// 配置策略：
  /// - 开发环境：所有日志输出到控制台
  /// - 生产环境：只记录错误和警告到历史记录，不输出控制台
  /// - 历史记录上限：500 条
  static void init() {
    talker = TalkerFlutter.init(
      settings: TalkerSettings(
        // 是否启用日志记录
        enabled: true,

        // 是否输出到控制台（仅开发环境）
        useConsoleLogs: kDebugMode,

        // 是否使用历史记录
        useHistory: true,

        // 历史记录最大数量
        maxHistoryItems: 500,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          // 日志级别过滤
          level: kDebugMode ? LogLevel.verbose : LogLevel.warning,

          // 是否启用日志颜色
          enableColors: true,
        ),
      ),
    );

    if (kDebugMode) {
      debugPrint('✅ Talker 日志系统已初始化（开发模式）');
      debugPrint('   - 控制台输出：已启用');
      debugPrint('   - 历史记录：已启用（最多 500 条）');
      debugPrint('   - 日志级别：VERBOSE');
    } else {
      // 生产环境只记录初始化日志
      talker.info('Talker 日志系统已初始化（生产模式）');
    }
  }

  /// 获取 Talker 实例
  ///
  /// 使用示例：
  /// ```dart
  /// final talker = TalkerConfig.instance;
  /// talker.info('用户登录成功');
  /// ```
  static Talker get instance => talker;

  /// 清空日志历史
  static void clearHistory() {
    talker.cleanHistory();
    debugPrint('🗑️ 日志历史已清空');
  }

  /// 获取日志历史记录
  static List<TalkerData> getHistory() {
    return talker.history;
  }

  /// 导出日志（用于问题诊断）
  ///
  /// 返回所有历史日志的文本格式
  static String exportLogs() {
    final buffer = StringBuffer();
    buffer.writeln('=== Flutter Run 日志导出 ===');
    buffer.writeln('时间: ${DateTime.now()}');
    buffer.writeln('环境: ${kDebugMode ? "开发" : "生产"}');
    buffer.writeln('总条数: ${talker.history.length}');
    buffer.writeln('');
    buffer.writeln('=== 日志详情 ===');

    for (final log in talker.history) {
      buffer.writeln('[${log.displayTime}] ${log.displayMessage}');
    }

    return buffer.toString();
  }
}
