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
///
/// 技术要点：
/// - **局部刷新优化**：移除 currentTime 字段，时间更新由 LiveTimeDisplay 组件独立管理
/// - 避免时间更新触发整个状态树重建
/// - 问候语类型仅在小时变化时更新（频率低）
class WorkspaceState extends Equatable {
  /// 问候语类型
  final GreetingType greetingType;

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
    this.todayMeetingCount = 0,
    this.quickActions = const [],
    this.meetingGroups = const [],
    this.status = LoadingStatus.initial,
    this.errorMessage,
  });

  /// 初始状态
  factory WorkspaceState.initial() {
    return WorkspaceState(
      greetingType: _getGreetingTypeFromHour(DateTime.now().hour),
      quickActions: QuickAction.getDefaultActions(),
    );
  }

  /// 根据小时获取问候语类型
  static GreetingType _getGreetingTypeFromHour(int hour) {
    if (hour < 6) {
      return GreetingType.lateNight;
    } else if (hour < 9) {
      return GreetingType.morning;
    } else if (hour < 12) {
      return GreetingType.forenoon;
    } else if (hour < 14) {
      return GreetingType.noon;
    } else if (hour < 18) {
      return GreetingType.afternoon;
    } else if (hour < 22) {
      return GreetingType.evening;
    } else {
      return GreetingType.lateNight;
    }
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
    int? todayMeetingCount,
    List<QuickAction>? quickActions,
    List<MeetingGroup>? meetingGroups,
    LoadingStatus? status,
    String? Function()? errorMessage,
  }) {
    return WorkspaceState(
      greetingType: greetingType ?? this.greetingType,
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
        todayMeetingCount,
        quickActions,
        meetingGroups,
        status,
        errorMessage,
      ];
}
