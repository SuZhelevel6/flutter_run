import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/models/quick_action.dart';

/// 快捷入口区域
///
/// 横向滚动的快捷功能入口列表
/// 技术要点：在纵向 CustomScrollView 中嵌套横向 ListView
class QuickActionsSection extends StatelessWidget {
  /// 快捷入口列表
  final List<QuickAction> actions;

  const QuickActionsSection({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              const Icon(
                Icons.flash_on,
                size: 20,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.workspaceQuickActions,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // 横向滚动列表
        SizedBox(
          height: 100, // 固定高度，避免无限约束冲突
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: actions.length,
            itemBuilder: (context, index) => _QuickActionCard(
              action: actions[index],
            ),
          ),
        ),
      ],
    );
  }
}

/// 快捷入口卡片
class _QuickActionCard extends StatelessWidget {
  final QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 80,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 图标
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  action.icon,
                  size: 24,
                  color: action.color,
                ),
              ),
              const SizedBox(height: 8),
              // 标签
              Text(
                _getLocalizedLabel(context),
                style: theme.textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (action.type) {
      case QuickActionType.whiteboard:
        return l10n.workspaceActionWhiteboard;
      case QuickActionType.screenCast:
        return l10n.workspaceActionScreencast;
      case QuickActionType.documents:
        return l10n.workspaceActionDocuments;
      case QuickActionType.settings:
        return l10n.workspaceActionSettings;
      case QuickActionType.more:
        return l10n.workspaceActionMore;
    }
  }

  void _handleTap(BuildContext context) {
    if (action.routePath != null) {
      context.go(action.routePath!);
    } else {
      // 显示功能暂未开放提示
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.workspaceFeatureNotAvailable(_getLocalizedLabel(context))),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
