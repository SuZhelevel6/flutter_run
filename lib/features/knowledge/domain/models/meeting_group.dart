import 'package:equatable/equatable.dart';

import 'meeting.dart';

/// 会议分组模型
///
/// 按日期对会议进行分组，用于列表展示
class MeetingGroup extends Equatable {
  /// 分组日期（只保留年月日）
  final DateTime date;

  /// 该日期下的会议列表
  final List<Meeting> meetings;

  const MeetingGroup({
    required this.date,
    required this.meetings,
  });

  /// 创建分组（自动规范化日期）
  factory MeetingGroup.create({
    required DateTime date,
    required List<Meeting> meetings,
  }) {
    // 规范化日期，只保留年月日
    final normalizedDate = DateTime(date.year, date.month, date.day);
    // 按开始时间排序
    final sortedMeetings = List<Meeting>.from(meetings)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return MeetingGroup(
      date: normalizedDate,
      meetings: sortedMeetings,
    );
  }

  /// 会议数量
  int get meetingCount => meetings.length;

  /// 是否为今天
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date == today;
  }

  /// 是否为明天
  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return date == tomorrow;
  }

  /// 格式化日期标题
  String get formattedTitle {
    if (isToday) return '今日会议';
    if (isTomorrow) return '明日会议';
    return '${date.month}月${date.day}日';
  }

  /// 格式化完整日期
  String get formattedDate {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.month}月${date.day}日 $weekday';
  }

  @override
  List<Object?> get props => [date, meetings];
}

/// 将会议列表按日期分组
List<MeetingGroup> groupMeetingsByDate(List<Meeting> meetings) {
  if (meetings.isEmpty) return [];

  // 按日期分组
  final groupMap = <DateTime, List<Meeting>>{};

  for (final meeting in meetings) {
    final date = DateTime(
      meeting.startTime.year,
      meeting.startTime.month,
      meeting.startTime.day,
    );

    groupMap.putIfAbsent(date, () => []);
    groupMap[date]!.add(meeting);
  }

  // 转换为 MeetingGroup 列表并按日期排序
  final groups = groupMap.entries
      .map((e) => MeetingGroup.create(date: e.key, meetings: e.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return groups;
}
