import 'package:equatable/equatable.dart';

import '../../domain/models/meeting_group.dart';
import '../../domain/models/quick_action.dart';

/// 加载状态枚举
enum LoadingStatus {
  /// 初始状态
  initial,

  /// 加载中
  loading,

  /// 加载成功
  success,

  /// 加载失败
  failure,
}

/// 问候语类型枚举
///
/// 用于在 Cubit 中表示问候类型，UI 层根据类型获取国际化字符串
enum GreetingType {
  /// 深夜 (22:00 - 06:00)
  lateNight,

  /// 早上 (06:00 - 09:00)
  morning,

  /// 上午 (09:00 - 12:00)
  forenoon,

  /// 中午 (12:00 - 14:00)
  noon,

  /// 下午 (14:00 - 18:00)
  afternoon,

  /// 晚上 (18:00 - 22:00)
  evening,
}

/// 会议工作台状态
///
/// 管理工作台页面的所有状态
class WorkspaceState extends Equatable {
  /// 问候语类型
  final GreetingType greetingType;

  /// 当前时间
  final DateTime currentTime;

  /// 今日会议数量
  final int todayMeetingCount;

  /// 快捷入口列表
  final List<QuickAction> quickActions;

  /// 会议分组列表
  final List<MeetingGroup> meetingGroups;

  /// 加载状态
  final LoadingStatus status;

  /// 错误信息
  final String? errorMessage;

  const WorkspaceState({
    this.greetingType = GreetingType.morning,
    required this.currentTime,
    this.todayMeetingCount = 0,
    this.quickActions = const [],
    this.meetingGroups = const [],
    this.status = LoadingStatus.initial,
    this.errorMessage,
  });

  /// 初始状态
  factory WorkspaceState.initial() {
    return WorkspaceState(
      currentTime: DateTime.now(),
      quickActions: QuickAction.getDefaultActions(),
    );
  }

  /// 是否正在加载
  bool get isLoading => status == LoadingStatus.loading;

  /// 是否加载成功
  bool get isSuccess => status == LoadingStatus.success;

  /// 是否加载失败
  bool get isFailure => status == LoadingStatus.failure;

  /// 是否有会议
  bool get hasMeetings => meetingGroups.isNotEmpty;

  /// 创建副本
  WorkspaceState copyWith({
    GreetingType? greetingType,
    DateTime? currentTime,
    int? todayMeetingCount,
    List<QuickAction>? quickActions,
    List<MeetingGroup>? meetingGroups,
    LoadingStatus? status,
    String? Function()? errorMessage,
  }) {
    return WorkspaceState(
      greetingType: greetingType ?? this.greetingType,
      currentTime: currentTime ?? this.currentTime,
      todayMeetingCount: todayMeetingCount ?? this.todayMeetingCount,
      quickActions: quickActions ?? this.quickActions,
      meetingGroups: meetingGroups ?? this.meetingGroups,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        greetingType,
        currentTime,
        todayMeetingCount,
        quickActions,
        meetingGroups,
        status,
        errorMessage,
      ];
}
