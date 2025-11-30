import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// 快捷入口类型枚举
enum QuickActionType {
  /// 白板
  whiteboard,

  /// 投屏
  screenCast,

  /// 文档
  documents,

  /// 设置
  settings,

  /// 更多
  more,
}

/// 快捷入口模型
///
/// 表示首��的快捷功能入口
class QuickAction extends Equatable {
  /// 入口类型
  final QuickActionType type;

  /// 显示标签
  final String label;

  /// 图标
  final IconData icon;

  /// 图标颜色
  final Color color;

  /// 路由路径（可选）
  final String? routePath;

  const QuickAction({
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
    this.routePath,
  });

  /// 获取默认快捷入口列表
  static List<QuickAction> getDefaultActions() {
    return const [
      QuickAction(
        type: QuickActionType.whiteboard,
        label: '白板',
        icon: Icons.edit_note,
        color: Colors.blue,
        routePath: '/painter',
      ),
      QuickAction(
        type: QuickActionType.screenCast,
        label: '投屏',
        icon: Icons.cast,
        color: Colors.orange,
      ),
      QuickAction(
        type: QuickActionType.documents,
        label: '文档',
        icon: Icons.folder_outlined,
        color: Colors.green,
      ),
      QuickAction(
        type: QuickActionType.settings,
        label: '设置',
        icon: Icons.settings_outlined,
        color: Colors.grey,
        routePath: '/settings',
      ),
      QuickAction(
        type: QuickActionType.more,
        label: '更多',
        icon: Icons.more_horiz,
        color: Colors.purple,
      ),
    ];
  }

  @override
  List<Object?> get props => [type, label, icon, color, routePath];
}
