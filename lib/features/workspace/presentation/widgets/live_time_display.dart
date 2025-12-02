import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

/// 实时时间显示组件
///
/// 技术要点：
/// - **局部刷新优化**：使用 StreamBuilder 监听时间流，只更新时间部分
/// - **避免父级重建**：时间更新不会触发父组件 rebuild
/// - **自动资源管理**：组件销毁时自动取消 Stream 订阅
///
/// 问题场景：
/// 原实现中时间更新会触发整个 GreetingHeader 重建，包括问候语、
/// 会议数量等不需要更新的部分，造成不必要的性能开销。
///
/// 解决方案：
/// 将时间显示抽离为独立组件，内部使用 Stream + StreamBuilder 实现
/// 自更新，父组件无需感知时间变化。
class LiveTimeDisplay extends StatefulWidget {
  const LiveTimeDisplay({super.key});

  @override
  State<LiveTimeDisplay> createState() => _LiveTimeDisplayState();
}

class _LiveTimeDisplayState extends State<LiveTimeDisplay> {
  /// 时间更新流控制器
  late final StreamController<DateTime> _timeController;

  /// 定时器
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeController = StreamController<DateTime>.broadcast();

    // 立即发送当前时间
    _timeController.add(DateTime.now());

    // 计算到下一分钟的延迟，确保时间对齐
    final now = DateTime.now();
    final secondsUntilNextMinute = 60 - now.second;

    // 先等待到下一分钟整点，再开始定时更新
    Future.delayed(Duration(seconds: secondsUntilNextMinute), () {
      if (!mounted) return;

      _timeController.add(DateTime.now());

      // 每分钟更新一次
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) {
          _timeController.add(DateTime.now());
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<DateTime>(
      stream: _timeController.stream,
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final currentTime = snapshot.data ?? DateTime.now();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 时间
            Text(
              _formatTime(currentTime),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            // 日期
            Text(
              _formatDate(context, currentTime),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final weekdays = [
      l10n.commonWeekdayMon,
      l10n.commonWeekdayTue,
      l10n.commonWeekdayWed,
      l10n.commonWeekdayThu,
      l10n.commonWeekdayFri,
      l10n.commonWeekdaySat,
      l10n.commonWeekdaySun,
    ];
    final weekday = weekdays[date.weekday - 1];
    return l10n.formatMonthDayWeekday(date.month, date.day, weekday);
  }
}
