import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/logging/app_logger.dart';
import '../../domain/repositories/meeting_repository.dart';
import 'workspace_state.dart';

/// 会议工作台 Cubit
///
/// 管理工作台页面的业务逻辑
///
/// 技术要点：
/// - **局部刷新优化**：移除 Timer 定时更新时间的逻辑
/// - 时间显示由 LiveTimeDisplay 组件独立管理，不再通过 Cubit 控制
/// - 减少不必要的状态更新，提升性能
class WorkspaceCubit extends Cubit<WorkspaceState> {
  final MeetingRepository _meetingRepository;

  WorkspaceCubit(this._meetingRepository) : super(WorkspaceState.initial());

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
}
