import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/logging/app_logger.dart';
import '../../domain/repositories/meeting_repository.dart';
import 'workspace_state.dart';

/// 会议工作台 Cubit
///
/// 管理工作台页面的业务逻辑
class WorkspaceCubit extends Cubit<WorkspaceState> {
  final MeetingRepository _meetingRepository;
  Timer? _timeUpdateTimer;

  WorkspaceCubit(this._meetingRepository) : super(WorkspaceState.initial());

  /// 初始化
  Future<void> init() async {
    _updateGreeting();
    _startTimeUpdater();
    await loadMeetings();
  }

  /// 加载会议数据
  Future<void> loadMeetings() async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      // 加载未来7天的会议
      final endDate = today.add(const Duration(days: 7));

      final meetingGroups = await _meetingRepository.getMeetings(
        startDate: today,
        endDate: endDate,
      );

      final todayCount = await _meetingRepository.getTodayMeetingCount();

      emit(state.copyWith(
        meetingGroups: meetingGroups,
        todayMeetingCount: todayCount,
        status: LoadingStatus.success,
        errorMessage: () => null,
      ));

      AppLogger.info('加载会议成功: ${meetingGroups.length} 个分组');
    } catch (e) {
      AppLogger.error('加载会议失败', e);
      emit(state.copyWith(
        status: LoadingStatus.failure,
        errorMessage: () => '加载失败: ${e.toString()}',
      ));
    }
  }

  /// 刷新数据
  Future<void> refresh() async {
    await _meetingRepository.refresh();
    await loadMeetings();
  }

  /// 更新问候语类型
  void _updateGreeting() {
    final hour = DateTime.now().hour;
    GreetingType greetingType;

    if (hour < 6) {
      greetingType = GreetingType.lateNight;
    } else if (hour < 9) {
      greetingType = GreetingType.morning;
    } else if (hour < 12) {
      greetingType = GreetingType.forenoon;
    } else if (hour < 14) {
      greetingType = GreetingType.noon;
    } else if (hour < 18) {
      greetingType = GreetingType.afternoon;
    } else if (hour < 22) {
      greetingType = GreetingType.evening;
    } else {
      greetingType = GreetingType.lateNight;
    }

    emit(state.copyWith(
      greetingType: greetingType,
      currentTime: DateTime.now(),
    ));
  }

  /// 启动时间更新定时器
  void _startTimeUpdater() {
    // 每分钟更新一次时间
    _timeUpdateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateGreeting();
    });
  }

  @override
  Future<void> close() {
    _timeUpdateTimer?.cancel();
    return super.close();
  }
}
