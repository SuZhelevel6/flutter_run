import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/whiteboard_cubit.dart';
import '../widgets/whiteboard_canvas.dart';

/// 会议白板页面
///
/// 功能：
/// - 自由绘制笔迹（贝塞尔曲线平滑）
/// - 绘制形状（矩形、圆形、箭头、直线）
/// - 橡皮擦擦除
/// - 撤销/重做
/// - 清空画布
///
/// 技术亮点：
/// - CustomPainter 自定义渲染
/// - 分层渲染优化性能
/// - 命令模式实现撤销重做
/// - Listener 精确手势处理
class PainterPage extends StatelessWidget {
  const PainterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WhiteboardCubit>(
      create: (_) => getIt<WhiteboardCubit>(),
      child: const _PainterPageContent(),
    );
  }
}

class _PainterPageContent extends StatelessWidget {
  const _PainterPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('会议白板'),
        centerTitle: true,
        actions: [
          // 撤销按钮
          BlocBuilder<WhiteboardCubit, dynamic>(
            buildWhen: (prev, curr) => prev.canUndo != curr.canUndo,
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.undo),
                onPressed: state.canUndo
                    ? () => context.read<WhiteboardCubit>().undo()
                    : null,
                tooltip: '撤销',
              );
            },
          ),
          // 重做按钮
          BlocBuilder<WhiteboardCubit, dynamic>(
            buildWhen: (prev, curr) => prev.canRedo != curr.canRedo,
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.redo),
                onPressed: state.canRedo
                    ? () => context.read<WhiteboardCubit>().redo()
                    : null,
                tooltip: '重做',
              );
            },
          ),
          // 清空按钮
          BlocBuilder<WhiteboardCubit, dynamic>(
            buildWhen: (prev, curr) => prev.isEmpty != curr.isEmpty,
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: state.isEmpty
                    ? null
                    : () => _showClearConfirmDialog(context),
                tooltip: '清空',
              );
            },
          ),
        ],
      ),
      body: const WhiteboardCanvas(),
    );
  }

  /// 显示清空确认对话框
  void _showClearConfirmDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('清空画布'),
          content: const Text('确定要清空所有内容吗？此操作可以撤销。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
                context.read<WhiteboardCubit>().clearCanvas();
              },
              child: const Text('清空'),
            ),
          ],
        );
      },
    );
  }
}
