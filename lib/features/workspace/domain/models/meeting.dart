import 'package:equatable/equatable.dart';

/// 会议状态枚举
enum MeetingStatus {
  /// 进行中
  ongoing,

  /// 即将开始
  upcoming,

  /// 已结束
  ended,
}

/// 参会人模型
class Attendee extends Equatable {
  /// 唯一标识符
  final String id;

  /// 姓名
  final String name;

  /// 头像 URL（可选）
  final String? avatarUrl;

  const Attendee({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

/// 会议模型
///
/// 表示一场会议的完整信息
class Meeting extends Equatable {
  /// 唯一标识符
  final String id;

  /// 会议标题
  final String title;

  /// 开始时间
  final DateTime startTime;

  /// 结束时间
  final DateTime endTime;

  /// 参会人列表
  final List<Attendee> attendees;

  /// 会议状态
  final MeetingStatus status;

  /// 会议室名称（可选）
  final String? roomName;

  /// 会议描述（可选）
  final String? description;

  const Meeting({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.attendees,
    required this.status,
    this.roomName,
    this.description,
  });

  /// 根据当前时间自动计算状态
  factory Meeting.create({
    required String id,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required List<Attendee> attendees,
    String? roomName,
    String? description,
  }) {
    final now = DateTime.now();
    MeetingStatus status;

    if (now.isBefore(startTime)) {
      status = MeetingStatus.upcoming;
    } else if (now.isAfter(endTime)) {
      status = MeetingStatus.ended;
    } else {
      status = MeetingStatus.ongoing;
    }

    return Meeting(
      id: id,
      title: title,
      startTime: startTime,
      endTime: endTime,
      attendees: attendees,
      status: status,
      roomName: roomName,
      description: description,
    );
  }

  /// 获取会议时长（分钟）
  int get durationMinutes => endTime.difference(startTime).inMinutes;

  /// 格式化时间范围
  String get formattedTimeRange {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 获取参会人摘要
  String get attendeesSummary {
    if (attendees.isEmpty) return '暂无参会人';
    if (attendees.length <= 3) {
      return attendees.map((a) => a.name).join('、');
    }
    return '${attendees.take(3).map((a) => a.name).join('、')} 等${attendees.length}人';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        startTime,
        endTime,
        attendees,
        status,
        roomName,
        description,
      ];
}
