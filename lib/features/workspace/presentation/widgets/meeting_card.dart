import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/models/meeting.dart';

/// 会议卡片组件
///
/// 显示单场会议的完整信息：
/// - 会议状态标签（进行中/即将开始/已结束）
/// - 会议标题
/// - 时间范围
/// - 参会人列表
/// - 会议室信息
///
/// 技术要点：
/// - **RepaintBoundary**：隔离重绘区域，防止卡片内部更新影响其他卡片
/// - **AutomaticKeepAliveClientMixin**：保持卡片状态，滚出屏幕后不销毁
/// - **const 优化**：静态装饰和样式使用 const，减少对象创建
/// - 使用 InkWell 实现点击效果
/// - 状态标签使用不同颜色区分
/// - 参会人头像堆叠显示
class MeetingCard extends StatefulWidget {
  /// 会议数据
  final Meeting meeting;

  /// 点击回调
  final VoidCallback? onTap;

  const MeetingCard({
    super.key,
    required this.meeting,
    this.onTap,
  });

  @override
  State<MeetingCard> createState() => _MeetingCardState();
}

class _MeetingCardState extends State<MeetingCard>
    with AutomaticKeepAliveClientMixin {
  /// 保持状态，滚出屏幕后不销毁
  ///
  /// 技术要点：
  /// - 返回 true 表示保持状态
  /// - 避免快速滚动时频繁创建/销毁组件
  /// - 以内存换取滚动流畅度
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // AutomaticKeepAliveClientMixin 要求调用 super.build
    super.build(context);

    final theme = Theme.of(context);

    // RepaintBoundary 隔离重绘区域
    // 当卡片内部状态变化时，不会触发其他卡片重绘
    return RepaintBoundary(
      child: Card(
        margin: _cardMargin,
        elevation: widget.meeting.status == MeetingStatus.ongoing ? 2 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: _cardBorderRadius,
          side: widget.meeting.status == MeetingStatus.ongoing
              ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: widget.onTap ?? () => _showMeetingDetails(context),
          borderRadius: _cardBorderRadius,
          child: Padding(
            padding: _cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 第一行：状态标签 + 时间
                _buildHeader(context, theme),
                const SizedBox(height: 12),

                // 第二行：会议标题
                Text(
                  widget.meeting.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // 第三行：会议室（如果有）
                if (widget.meeting.roomName != null) ...[
                  _buildRoomInfo(theme),
                  const SizedBox(height: 8),
                ],

                // 第四行：参会人
                _buildAttendees(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建头部：状态标签 + 时间
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final l10n = context.l10n;
    return Row(
      children: [
        // 状态标签
        _StatusLabel(status: widget.meeting.status),
        const SizedBox(width: 12),

        // 时间范围
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                widget.meeting.formattedTimeRange,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // 时长
        Container(
          padding: _durationPadding,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: _durationBorderRadius,
          ),
          child: Text(
            l10n.workspaceMeetingDuration(widget.meeting.durationMinutes),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建会议室信息
  Widget _buildRoomInfo(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.meeting_room_outlined,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          widget.meeting.roomName!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// 构建参会人信息
  Widget _buildAttendees(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        // 头像堆叠
        _AvatarStack(attendees: widget.meeting.attendees),
        const SizedBox(width: 8),

        // 参会人摘要
        Expanded(
          child: Text(
            _getAttendeesSummary(context),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getAttendeesSummary(BuildContext context) {
    final l10n = context.l10n;
    final attendees = widget.meeting.attendees;

    if (attendees.isEmpty) return l10n.workspaceNoAttendees;
    if (attendees.length <= 3) {
      return attendees.map((a) => a.name).join('、');
    }
    final names = attendees.take(3).map((a) => a.name).join('、');
    return l10n.workspaceAttendeesAndMore(names, attendees.length);
  }

  /// 显示会议详情（临时实现）
  void _showMeetingDetails(BuildContext context) {
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.workspaceViewMeeting(widget.meeting.title)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ==================== const 优化 ====================
  // 静态常量避免每次 build 时创建新对象

  static const _cardMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 6);
  static const _cardPadding = EdgeInsets.all(16);
  static const _cardBorderRadius = BorderRadius.all(Radius.circular(12));
  static const _durationPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 2);
  static const _durationBorderRadius = BorderRadius.all(Radius.circular(4));
}

/// 状态标签组件
class _StatusLabel extends StatelessWidget {
  final MeetingStatus status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, bgColor) = _getStatusStyle(context);

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: _borderRadius,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  (String, Color, Color) _getStatusStyle(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    switch (status) {
      case MeetingStatus.ongoing:
        return (
          l10n.workspaceMeetingStatusOngoing,
          Colors.white,
          theme.colorScheme.primary,
        );
      case MeetingStatus.upcoming:
        return (
          l10n.workspaceMeetingStatusUpcoming,
          theme.colorScheme.tertiary,
          theme.colorScheme.tertiaryContainer,
        );
      case MeetingStatus.ended:
        return (
          l10n.workspaceMeetingStatusEnded,
          theme.colorScheme.onSurfaceVariant,
          theme.colorScheme.surfaceContainerHighest,
        );
    }
  }

  // const 优化
  static const _padding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const _borderRadius = BorderRadius.all(Radius.circular(4));
}

/// 头像堆叠组件
///
/// 技术要点：
/// - const 颜色数组避免重复创建
/// - 使用 static const 定义尺寸常量
class _AvatarStack extends StatelessWidget {
  final List<Attendee> attendees;

  /// 最大显示头像数量
  static const int _maxDisplay = 3;

  /// 头像尺寸
  static const double _avatarSize = 28;

  /// 头像重叠距离
  static const double _overlap = 8;

  const _AvatarStack({
    required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayCount = attendees.length.clamp(0, _maxDisplay);
    final hasMore = attendees.length > _maxDisplay;

    if (attendees.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _avatarSize + (displayCount - 1 + (hasMore ? 1 : 0)) * (_avatarSize - _overlap),
      height: _avatarSize,
      child: Stack(
        children: [
          // 显示的头像
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * (_avatarSize - _overlap),
              child: _buildAvatar(
                theme,
                attendees[i],
              ),
            ),

          // 更多数量指示
          if (hasMore)
            Positioned(
              left: displayCount * (_avatarSize - _overlap),
              child: Container(
                width: _avatarSize,
                height: _avatarSize,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+${attendees.length - _maxDisplay}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme, Attendee attendee) {
    // 根据名字生成颜色
    final colorIndex = attendee.name.hashCode % _avatarColors.length;
    final bgColor = _avatarColors[colorIndex];

    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 2,
        ),
      ),
      child: attendee.avatarUrl != null
          ? ClipOval(
              child: Image.network(
                attendee.avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitial(attendee),
              ),
            )
          : _buildInitial(attendee),
    );
  }

  Widget _buildInitial(Attendee attendee) {
    return Center(
      child: Text(
        attendee.name.isNotEmpty ? attendee.name[0] : '?',
        style: _initialTextStyle,
      ),
    );
  }

  // const 优化：预定义样式和颜色
  static const _initialTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // 预定义的头像背景色
  static const _avatarColors = [
    Color(0xFF5C6BC0), // Indigo
    Color(0xFF26A69A), // Teal
    Color(0xFFEF5350), // Red
    Color(0xFF66BB6A), // Green
    Color(0xFFAB47BC), // Purple
    Color(0xFFFFCA28), // Amber
    Color(0xFF42A5F5), // Blue
    Color(0xFFEC407A), // Pink
  ];
}
