import '../models/meeting_group.dart';

/// 会议仓储接口
///
/// 定义会议数据操作契约
abstract class MeetingRepository {
  /// 获取会议列表（按日期分组）
  ///
  /// [startDate] 起始日期
  /// [endDate] 结���日期
  Future<List<MeetingGroup>> getMeetings({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 获取今日会议数量
  Future<int> getTodayMeetingCount();

  /// 刷新会议数据
  Future<void> refresh();
}
