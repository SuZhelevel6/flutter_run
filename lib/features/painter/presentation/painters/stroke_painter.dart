import 'package:flutter/material.dart';

import '../../domain/models/stroke.dart';
import '../../domain/utils/stroke_smoother.dart';

/// 笔迹绘制器
///
/// 负责绑制已完成的笔迹列表
/// 使用贝塞尔曲线平滑处理确保笔迹流畅
class StrokePainter extends CustomPainter {
  /// 已完成的笔迹列表
  final List<Stroke> strokes;

  StrokePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }
  }

  /// 绘制单条笔迹
  void _drawStroke(Canvas canvas, Stroke stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    if (stroke.points.length == 1) {
      // 单点情况：画一个圆点
      canvas.drawCircle(
        stroke.points.first,
        stroke.strokeWidth / 2,
        paint..style = PaintingStyle.fill,
      );
      return;
    }

    // 使用贝塞尔曲线平滑绘制
    final path = StrokeSmoother.smoothPath(stroke.points);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) {
    // 只有笔迹列表变化时才重绘
    // 使用 identical 快速比较引用，避免深度比较
    return !identical(strokes, oldDelegate.strokes);
  }
}

/// 预览笔迹绘制器
///
/// 负责绘制当前正在绘制的笔迹（实时预览）
/// 与 StrokePainter 分离以实现独立重绘，优化性能
class PreviewStrokePainter extends CustomPainter {
  /// 当前正在绘制的笔迹
  final Stroke? stroke;

  PreviewStrokePainter({this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    if (stroke == null || stroke!.points.isEmpty) return;

    final paint = Paint()
      ..color = stroke!.color
      ..strokeWidth = stroke!.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    if (stroke!.points.length == 1) {
      // 单点情况：画一个圆点
      canvas.drawCircle(
        stroke!.points.first,
        stroke!.strokeWidth / 2,
        paint..style = PaintingStyle.fill,
      );
      return;
    }

    // 使用贝塞尔曲线平滑绘制
    final path = StrokeSmoother.smoothPath(stroke!.points);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PreviewStrokePainter oldDelegate) {
    // 预览层需要频繁更新
    return stroke != oldDelegate.stroke;
  }
}

/// 橡皮擦轨迹绘制器
///
/// 显示橡皮擦的擦除路径，提供视觉反馈
class EraserPainter extends CustomPainter {
  /// 橡皮擦路径
  final List<Offset> eraserPath;

  /// 橡皮擦大小
  final double eraserSize;

  EraserPainter({
    required this.eraserPath,
    required this.eraserSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (eraserPath.isEmpty) return;

    // 绘制橡皮擦轨迹（半透明灰色）
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = eraserSize
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    if (eraserPath.length == 1) {
      // 单点情况
      canvas.drawCircle(eraserPath.first, eraserSize / 2, paint);
      return;
    }

    final path = Path();
    path.moveTo(eraserPath.first.dx, eraserPath.first.dy);

    for (int i = 1; i < eraserPath.length; i++) {
      path.lineTo(eraserPath[i].dx, eraserPath[i].dy);
    }

    canvas.drawPath(path, paint);

    // 绘制当前橡皮擦位置指示器
    if (eraserPath.isNotEmpty) {
      final indicatorPaint = Paint()
        ..color = Colors.grey.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(eraserPath.last, eraserSize / 2, indicatorPaint);
    }
  }

  @override
  bool shouldRepaint(EraserPainter oldDelegate) {
    return eraserPath != oldDelegate.eraserPath ||
        eraserSize != oldDelegate.eraserSize;
  }
}
