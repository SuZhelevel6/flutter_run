import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/whiteboard_tool.dart';
import '../cubit/whiteboard_cubit.dart';
import '../cubit/whiteboard_state.dart';

/// 白板工具栏
///
/// 显示所有可用的绘图工具，支持：
/// - 画笔
/// - 橡皮擦
/// - 形状工具（矩形、圆形、箭头、直线）
class WhiteboardToolbar extends StatelessWidget {
  const WhiteboardToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocSelector<WhiteboardCubit, WhiteboardState, WhiteboardTool>(
        selector: (state) => state.currentTool,
        builder: (context, currentTool) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToolButton(
                tool: WhiteboardTool.pen,
                icon: Icons.edit,
                label: '画笔',
                isSelected: currentTool == WhiteboardTool.pen,
              ),
              _ToolButton(
                tool: WhiteboardTool.eraser,
                icon: Icons.auto_fix_high,
                label: '橡皮擦',
                isSelected: currentTool == WhiteboardTool.eraser,
              ),
              const _ToolDivider(),
              _ToolButton(
                tool: WhiteboardTool.line,
                icon: Icons.horizontal_rule,
                label: '直线',
                isSelected: currentTool == WhiteboardTool.line,
              ),
              _ToolButton(
                tool: WhiteboardTool.arrow,
                icon: Icons.arrow_forward,
                label: '箭头',
                isSelected: currentTool == WhiteboardTool.arrow,
              ),
              _ToolButton(
                tool: WhiteboardTool.rectangle,
                icon: Icons.rectangle_outlined,
                label: '矩形',
                isSelected: currentTool == WhiteboardTool.rectangle,
              ),
              _ToolButton(
                tool: WhiteboardTool.circle,
                icon: Icons.circle_outlined,
                label: '圆形',
                isSelected: currentTool == WhiteboardTool.circle,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 工具按钮
class _ToolButton extends StatelessWidget {
  final WhiteboardTool tool;
  final IconData icon;
  final String label;
  final bool isSelected;

  const _ToolButton({
    required this.tool,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: label,
      child: Material(
        color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => context.read<WhiteboardCubit>().selectTool(tool),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 24,
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// 工具分隔线
class _ToolDivider extends StatelessWidget {
  const _ToolDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
    );
  }
}
