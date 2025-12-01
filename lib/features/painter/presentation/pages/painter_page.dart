import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../cubit/whiteboard_cubit.dart';
import '../cubit/whiteboard_state.dart';
import '../widgets/color_picker.dart';
import '../widgets/stroke_width_picker.dart';
import '../widgets/whiteboard_canvas.dart';
import '../widgets/whiteboard_toolbar.dart';

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
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 撤销按钮
            BlocSelector<WhiteboardCubit, WhiteboardState, bool>(
              selector: (state) => state.canUndo,
              builder: (context, canUndo) {
                return IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed:
                      canUndo ? () => context.read<WhiteboardCubit>().undo() : null,
                  tooltip: context.l10n.painterUndo,
                );
              },
            ),
            // 重做按钮
            BlocSelector<WhiteboardCubit, WhiteboardState, bool>(
              selector: (state) => state.canRedo,
              builder: (context, canRedo) {
                return IconButton(
                  icon: const Icon(Icons.redo),
                  onPressed:
                      canRedo ? () => context.read<WhiteboardCubit>().redo() : null,
                  tooltip: context.l10n.painterRedo,
                );
              },
            ),
            // 清空按钮
            BlocSelector<WhiteboardCubit, WhiteboardState, bool>(
              selector: (state) => state.isEmpty,
              builder: (context, isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: isEmpty ? null : () => _showClearConfirmDialog(context),
                  tooltip: context.l10n.painterClear,
                );
              },
            ),
          ],
        ),
        leadingWidth: 144,
        title: Text(context.l10n.painterTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 画布
          const WhiteboardCanvas(),

          // 顶部工具栏
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const WhiteboardToolbar(),
                    const SizedBox(width: 16),
                    const ColorPicker(),
                    const SizedBox(width: 16),
                    const StrokeWidthPicker(),
                  ],
                ),
              ),
            ),
          ),

          // 底部快捷栏（移动端适配）
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  /// 构建底部快捷栏
  Widget _buildBottomBar(BuildContext context) {
    // 检测是否为窄屏（移动端）
    final isNarrowScreen = MediaQuery.of(context).size.width < 600;

    if (!isNarrowScreen) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MiniColorPicker(),
          MiniStrokeWidthPicker(),
        ],
      ),
    );
  }

  /// 显示清空确认对话框
  void _showClearConfirmDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.painterClearCanvasTitle),
          content: Text(l10n.painterClearCanvasMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
                context.read<WhiteboardCubit>().clearCanvas();
              },
              child: Text(l10n.painterClear),
            ),
          ],
        );
      },
    );
  }
}
