import '../../domain/models/meeting.dart';
import '../../domain/models/meeting_group.dart';
import '../../domain/repositories/meeting_repository.dart';

/// 会议仓储实现
///
/// 使用模拟数据，实际项目中可替换为真实 API 调用
class MeetingRepositoryImpl implements MeetingRepository {
  @override
  Future<List<MeetingGroup>> getMeetings({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));

    // 生成模拟数据
    final meetings = _generateMockMeetings(startDate, endDate);
    return groupMeetingsByDate(meetings);
  }

  @override
  Future<int> getTodayMeetingCount() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final groups = await getMeetings(startDate: today, endDate: tomorrow);
    if (groups.isEmpty) return 0;

    final todayGroup = groups.firstWhere(
      (g) => g.isToday,
      orElse: () => MeetingGroup(date: today, meetings: const []),
    );
    return todayGroup.meetingCount;
  }

  @override
  Future<void> refresh() async {
    // 实际项目中可清除缓存、重新请求等
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// 生成模拟会议数据
  List<Meeting> _generateMockMeetings(DateTime startDate, DateTime endDate) {
    final meetings = <Meeting>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 今日会议
    meetings.addAll([
      Meeting.create(
        id: '1',
        title: '产品需求评审会',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 10)),
        attendees: const [
          Attendee(id: '1', name: '张三'),
          Attendee(id: '2', name: '李四'),
          Attendee(id: '3', name: '王五'),
          Attendee(id: '4', name: '赵六'),
          Attendee(id: '5', name: '钱七'),
        ],
        roomName: '3号会议室',
      ),
      Meeting.create(
        id: '2',
        title: '技术方案讨论',
        startTime: today.add(const Duration(hours: 14)),
        endTime: today.add(const Duration(hours: 15, minutes: 30)),
        attendees: const [
          Attendee(id: '1', name: '开发组'),
          Attendee(id: '2', name: '测试组'),
        ],
        roomName: '5号会议室',
        description: '讨论新版本的技术实现方案',
      ),
      Meeting.create(
        id: '3',
        title: '每日站会',
        startTime: today.add(const Duration(hours: 17)),
        endTime: today.add(const Duration(hours: 17, minutes: 15)),
        attendees: const [
          Attendee(id: '1', name: '全体成员'),
        ],
        roomName: '开放区',
      ),
    ]);

    // 明日会议
    final tomorrow = today.add(const Duration(days: 1));
    meetings.addAll([
      Meeting.create(
        id: '4',
        title: '周例会',
        startTime: tomorrow.add(const Duration(hours: 10)),
        endTime: tomorrow.add(const Duration(hours: 11)),
        attendees: const [
          Attendee(id: '1', name: '全体成员'),
        ],
        roomName: '大会议室',
      ),
      Meeting.create(
        id: '5',
        title: '客户演示',
        startTime: tomorrow.add(const Duration(hours: 14)),
        endTime: tomorrow.add(const Duration(hours: 16)),
        attendees: const [
          Attendee(id: '1', name: '产品经理'),
          Attendee(id: '2', name: '销售'),
          Attendee(id: '3', name: '客户方'),
        ],
        roomName: '1号会议室',
        description: '向客户演示新功能',
      ),
    ]);

    // 后天会议
    final dayAfterTomorrow = today.add(const Duration(days: 2));
    meetings.add(
      Meeting.create(
        id: '6',
        title: '培训分享会',
        startTime: dayAfterTomorrow.add(const Duration(hours: 15)),
        endTime: dayAfterTomorrow.add(const Duration(hours: 17)),
        attendees: const [
          Attendee(id: '1', name: '技术团队'),
        ],
        roomName: '培训室',
        description: 'Flutter 技术分享',
      ),
    );

    // 过滤日期范围内的会议
    return meetings.where((m) {
      final meetingDate = DateTime(
        m.startTime.year,
        m.startTime.month,
        m.startTime.day,
      );
      return !meetingDate.isBefore(startDate) && meetingDate.isBefore(endDate);
    }).toList();
  }
}
