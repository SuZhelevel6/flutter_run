import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/models/meeting_group.dart';

/// 日期标题吸顶代理
///
/// 实现 SliverPersistentHeader 的吸顶效果
/// 技术要点：
/// - minExtent/maxExtent 控制收缩范围
/// - overlapsContent 判断是否覆盖内容（用于添加阴影）
/// - pinned: true 实现吸顶
class DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// 会议分组
  final MeetingGroup meetingGroup;

  DateHeaderDelegate({required this.meetingGroup});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  bool shouldRebuild(covariant DateHeaderDelegate oldDelegate) {
    return meetingGroup != oldDelegate.meetingGroup;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      height: maxExtent,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        // 吸顶时添加阴影效果
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 日历图标
          Icon(
            Icons.calendar_today,
            size: 18,
            color: _getTitleColor(theme),
          ),
          const SizedBox(width: 8),
          // 日期标题
          Text(
            _getFormattedTitle(context),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTitleColor(theme),
            ),
          ),
          const SizedBox(width: 8),
          // 完整日期
          if (!meetingGroup.isToday && !meetingGroup.isTomorrow)
            Text(
              _getFormattedDate(context),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const Spacer(),
          // 会议数量
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.workspaceMeetingCountUnit(meetingGroup.meetingCount),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedTitle(BuildContext context) {
    final l10n = context.l10n;
    if (meetingGroup.isToday) return l10n.workspaceTodayMeetings;
    if (meetingGroup.isTomorrow) return l10n.workspaceTomorrowMeetings;
    return l10n.formatMonthDay(meetingGroup.date.month, meetingGroup.date.day);
  }

  String _getFormattedDate(BuildContext context) {
    final l10n = context.l10n;
    final date = meetingGroup.date;
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

  Color _getTitleColor(ThemeData theme) {
    if (meetingGroup.isToday) {
      return theme.colorScheme.primary;
    }
    return theme.colorScheme.onSurface;
  }
}
