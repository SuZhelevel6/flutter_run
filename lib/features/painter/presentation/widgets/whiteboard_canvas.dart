import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/shape.dart';
import '../../domain/models/stroke.dart';
import '../cubit/whiteboard_cubit.dart';
import '../cubit/whiteboard_state.dart';
import '../painters/shape_painter.dart';
import '../painters/stroke_painter.dart';

/// 白板画布组件
///
/// 采用分层渲染策略优化性能：
/// - 背景层：静态网格，使用 RepaintBoundary 隔离
/// - 笔迹层：已完成的笔迹，仅在笔迹列表变化时重绘
/// - 形状层：已完成的形状，仅在形状列表变化时重绘
/// - 预览层：当前正在绘制的内容，高频更新
/// - 橡皮擦层：橡皮擦轨迹显示
class WhiteboardCanvas extends StatelessWidget {
  const WhiteboardCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景层 - 使用 RepaintBoundary 隔离，避免随画布重绘
        const RepaintBoundary(
          child: _BackgroundLayer(),
        ),

        // 笔迹层 - 已完成的笔迹
        BlocSelector<WhiteboardCubit, WhiteboardState, List<Stroke>>(
          selector: (state) => state.strokes,
          builder: (context, strokes) {
            return RepaintBoundary(
              child: CustomPaint(
                painter: StrokePainter(strokes: strokes),
                size: Size.infinite,
              ),
            );
          },
        ),

        // 形状层 - 已完成的形状
        BlocSelector<WhiteboardCubit, WhiteboardState, List<Shape>>(
          selector: (state) => state.shapes,
          builder: (context, shapes) {
            return RepaintBoundary(
              child: CustomPaint(
                painter: ShapePainter(shapes: shapes),
                size: Size.infinite,
              ),
            );
          },
        ),

        // 预览笔迹层 - 当前正在绘制的笔迹（高频更新）
        BlocSelector<WhiteboardCubit, WhiteboardState, Stroke?>(
          selector: (state) => state.currentStroke,
          builder: (context, currentStroke) {
            if (currentStroke == null) return const SizedBox.shrink();
            return CustomPaint(
              painter: PreviewStrokePainter(stroke: currentStroke),
              size: Size.infinite,
            );
          },
        ),

        // 预览形状层 - 当前正在绘制的形状（高频更新）
        BlocSelector<WhiteboardCubit, WhiteboardState, Shape?>(
          selector: (state) => state.currentShape,
          builder: (context, currentShape) {
            if (currentShape == null) return const SizedBox.shrink();
            return CustomPaint(
              painter: PreviewShapePainter(shape: currentShape),
              size: Size.infinite,
            );
          },
        ),

        // 橡皮擦层 - 显示橡皮擦轨迹
        BlocSelector<WhiteboardCubit, WhiteboardState, _EraserState>(
          selector: (state) =>
              _EraserState(state.eraserPath, state.eraserSize),
          builder: (context, eraserState) {
            if (eraserState.path.isEmpty) return const SizedBox.shrink();
            return CustomPaint(
              painter: EraserPainter(
                eraserPath: eraserState.path,
                eraserSize: eraserState.size,
              ),
              size: Size.infinite,
            );
          },
        ),

        // 手势检测层
        const _GestureLayer(),
      ],
    );
  }
}

/// 橡皮擦状态（用于 BlocSelector）
class _EraserState {
  final List<Offset> path;
  final double size;

  _EraserState(this.path, this.size);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _EraserState && path == other.path && size == other.size;
  }

  @override
  int get hashCode => Object.hash(path, size);
}

/// 背景层
///
/// 绘制白板背景（纯白色或网格）
class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(),
      size: Size.infinite,
    );
  }
}

/// 背景绘制器
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制白色背景
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, paint);

    // 绘制网格（可选）
    _drawGrid(canvas, size);
  }

  /// 绘制网格
  void _drawGrid(Canvas canvas, Size size) {
    const gridSize = 20.0;
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    // 绘制垂直线
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // 绘制水平线
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) => false;
}

/// 手势检测层
///
/// 使用 Listener 而非 GestureDetector，以获得更精确的触摸事件
/// 并避免与其他手势识别器冲突
class _GestureLayer extends StatelessWidget {
  const _GestureLayer();

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        context.read<WhiteboardCubit>().startDrawing(event.localPosition);
      },
      onPointerMove: (event) {
        context.read<WhiteboardCubit>().continueDrawing(event.localPosition);
      },
      onPointerUp: (event) {
        context.read<WhiteboardCubit>().endDrawing();
      },
      onPointerCancel: (event) {
        context.read<WhiteboardCubit>().cancelDrawing();
      },
      child: const SizedBox.expand(),
    );
  }
}
