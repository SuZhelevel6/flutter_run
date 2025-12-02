import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/models/meeting_group.dart';
import '../cubit/workspace_cubit.dart';
import '../cubit/workspace_state.dart';
import '../widgets/date_header_delegate.dart';
import '../widgets/greeting_header.dart';
import '../widgets/meeting_card.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/workspace_skeleton.dart';

/// 会议工作台页面
///
/// 改造自原 Knowledge 页面，实现智能会议平板的工作台功能
///
/// 技术要点：
/// - CustomScrollView + Sliver 实现复杂滚动布局
/// - SliverPersistentHeader 实现日期吸顶效果
/// - SliverToBoxAdapter 嵌入普通 Widget
/// - BlocProvider 提供状态管理
/// - **骨架屏加载**：使用 Shimmer 效果的骨架屏替代单调的加载指示器
class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkspaceCubit>()..loadMeetings(),
      child: const _WorkspaceView(),
    );
  }
}

class _WorkspaceView extends StatelessWidget {
  const _WorkspaceView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WorkspaceCubit, WorkspaceState>(
        builder: (context, state) {
          return switch (state.status) {
            LoadingStatus.initial || LoadingStatus.loading => const _LoadingView(),
            LoadingStatus.failure => _ErrorView(
                onRetry: () => context.read<WorkspaceCubit>().loadMeetings(),
              ),
            LoadingStatus.success => _SuccessView(state: state),
          };
        },
      ),
    );
  }
}

/// 加载中视图（骨架屏）
///
/// 技术要点：
/// - 使用骨架屏替代单调的 CircularProgressIndicator
/// - 骨架屏结构与真实内容一致，减少布局跳动
/// - Shimmer 动画提示用户内容正在加载
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const WorkspaceSkeleton();
  }
}

/// 错误视图
class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.workspaceLoadFailed,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.workspaceCheckNetwork,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.workspaceRetry),
          ),
        ],
      ),
    );
  }
}

/// 成功加载后的主视图
class _SuccessView extends StatelessWidget {
  final WorkspaceState state;

  const _SuccessView({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<WorkspaceCubit>().loadMeetings(),
      child: CustomScrollView(
        slivers: [
          // 顶部安全区域
          const SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: SizedBox.shrink(),
            ),
          ),

          // 问候语头部（时间显示已使用 LiveTimeDisplay 局部刷新）
          SliverToBoxAdapter(
            child: GreetingHeader(
              greetingType: state.greetingType,
              meetingCount: state.todayMeetingCount,
            ),
          ),

          // 快捷入口
          SliverToBoxAdapter(
            child: QuickActionsSection(
              actions: state.quickActions,
            ),
          ),

          // 分隔线
          const SliverToBoxAdapter(
            child: Divider(height: 32, indent: 20, endIndent: 20),
          ),

          // 会议列表标题
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.event_note,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.workspaceMeetingSchedule,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // 会议分组列表（日期吸顶 + 会议卡片）
          ..._buildMeetingGroups(state.meetingGroups),

          // 底部安全区域
          const SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: SizedBox(height: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建会议分组列表
  ///
  /// 每个分组包含：
  /// 1. SliverPersistentHeader（日期吸顶头）
  /// 2. SliverList（该日期下的会议卡片）
  List<Widget> _buildMeetingGroups(List<MeetingGroup> groups) {
    if (groups.isEmpty) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyMeetingsView(),
        ),
      ];
    }

    final slivers = <Widget>[];

    for (final group in groups) {
      // 日期吸顶头
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: DateHeaderDelegate(meetingGroup: group),
        ),
      );

      // 该日期下的会议卡片列表
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => MeetingCard(
              meeting: group.meetings[index],
            ),
            childCount: group.meetings.length,
          ),
        ),
      );
    }

    return slivers;
  }
}

/// 空会议视图
class _EmptyMeetingsView extends StatelessWidget {
  const _EmptyMeetingsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.workspaceNoMeetings,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.workspaceEnjoyYourDay,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
