import 'package:flutter/material.dart';

/// 问候语头部组件
///
/// 显示：
/// - 时段问候语（早上好、下午好等）
/// - 今日会议数量
/// - 当前时间
class GreetingHeader extends StatelessWidget {
  /// 问候语
  final String greeting;

  /// 今日会议数量
  final int meetingCount;

  /// 当前时间
  final DateTime currentTime;

  const GreetingHeader({
    super.key,
    required this.greeting,
    required this.meetingCount,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧：问候语和会议数量
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 问候语
                Row(
                  children: [
                    Text(
                      '👋 ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      '$greeting，3号会议室',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 会议数量
                Text(
                  meetingCount > 0 ? '今天有 $meetingCount 场会议' : '今天暂无会议安排',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // 右侧：时间显示
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 时间
              Text(
                _formatTime(currentTime),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              // 日期
              Text(
                _formatDate(currentTime),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.month}月${date.day}日 $weekday';
  }
}
