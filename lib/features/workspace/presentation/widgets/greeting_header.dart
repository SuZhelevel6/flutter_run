import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../cubit/workspace_state.dart';

/// 问候语头部组件
///
/// 显示：
/// - 时段问候语（早上好、下午好等）
/// - 今日会议数量
/// - 当前���间
class GreetingHeader extends StatelessWidget {
  /// 问候语类型
  final GreetingType greetingType;

  /// 今日会议数量
  final int meetingCount;

  /// 当前时间
  final DateTime currentTime;

  const GreetingHeader({
    super.key,
    required this.greetingType,
    required this.meetingCount,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

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
                    const Text(
                      '👋 ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      '${_getGreetingText(context)}，${l10n.workspaceRoomName}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 会议数量
                Text(
                  meetingCount > 0
                      ? l10n.workspaceMeetingCount(meetingCount)
                      : l10n.workspaceNoMeetingToday,
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
                _formatDate(context, currentTime),
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

  /// 根据问候类型获取国际化问候语
  String _getGreetingText(BuildContext context) {
    final l10n = context.l10n;
    switch (greetingType) {
      case GreetingType.lateNight:
        return l10n.workspaceGreetingLateNight;
      case GreetingType.morning:
        return l10n.workspaceGreetingMorning;
      case GreetingType.forenoon:
        return l10n.workspaceGreetingForenoon;
      case GreetingType.noon:
        return l10n.workspaceGreetingNoon;
      case GreetingType.afternoon:
        return l10n.workspaceGreetingAfternoon;
      case GreetingType.evening:
        return l10n.workspaceGreetingEvening;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final weekdays = [
      l10n.commonWeekdayMon,
      l10n.commonWeekdayTue,
      l10n.commonWeekdayWed,
      l10n.commonWeekdayThu,
      l10n.commonWeekdayFri,
      l10n.commonWeekdaySat,
      l10n.commonWeekdaySun,
    ];
    final weekday = weekdays[date.weekday - 1];
    return l10n.formatMonthDayWeekday(date.month, date.day, weekday);
  }
}
