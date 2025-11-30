import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/models/shape.dart';

/// 形状绘制器
///
/// 负责绘制已完成的形状列表
/// 支持矩形、圆形、箭头、直线
class ShapePainter extends CustomPainter {
  /// 已完成的形状列表
  final List<Shape> shapes;

  ShapePainter({required this.shapes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      _drawShape(canvas, shape);
    }
  }

  /// 绘制单个形状
  void _drawShape(Canvas canvas, Shape shape) {
    final paint = Paint()
      ..color = shape.color
      ..strokeWidth = shape.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = shape.filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..isAntiAlias = true;

    switch (shape.type) {
      case ShapeType.rectangle:
        _drawRectangle(canvas, shape, paint);
        break;
      case ShapeType.circle:
        _drawCircle(canvas, shape, paint);
        break;
      case ShapeType.arrow:
        _drawArrow(canvas, shape, paint);
        break;
      case ShapeType.line:
        _drawLine(canvas, shape, paint);
        break;
    }
  }

  /// 绘制矩形
  void _drawRectangle(Canvas canvas, Shape shape, Paint paint) {
    final rect = Rect.fromPoints(shape.startPoint, shape.endPoint);
    canvas.drawRect(rect, paint);
  }

  /// 绘制圆形/椭圆
  void _drawCircle(Canvas canvas, Shape shape, Paint paint) {
    final rect = Rect.fromPoints(shape.startPoint, shape.endPoint);
    canvas.drawOval(rect, paint);
  }

  /// 绘制箭头
  void _drawArrow(Canvas canvas, Shape shape, Paint paint) {
    final start = shape.startPoint;
    final end = shape.endPoint;

    // 绘制主线
    canvas.drawLine(start, end, paint);

    // 计算箭头方向
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final angle = math.atan2(dy, dx);

    // 箭头大小（根据线条粗细调整）
    final arrowSize = shape.strokeWidth * 4;
    const arrowAngle = math.pi / 6; // 30度

    // 计算箭头两个端点
    final arrow1 = Offset(
      end.dx - arrowSize * math.cos(angle - arrowAngle),
      end.dy - arrowSize * math.sin(angle - arrowAngle),
    );
    final arrow2 = Offset(
      end.dx - arrowSize * math.cos(angle + arrowAngle),
      end.dy - arrowSize * math.sin(angle + arrowAngle),
    );

    // 绘制箭头
    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrow1.dx, arrow1.dy)
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrow2.dx, arrow2.dy);

    canvas.drawPath(arrowPath, paint);
  }

  /// 绘制直线
  void _drawLine(Canvas canvas, Shape shape, Paint paint) {
    canvas.drawLine(shape.startPoint, shape.endPoint, paint);
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) {
    return !identical(shapes, oldDelegate.shapes);
  }
}

/// 预览形状绘制器
///
/// 负责绘制当前正在绘制的形状（实时预览）
class PreviewShapePainter extends CustomPainter {
  /// 当前正在绘制的形状
  final Shape? shape;

  PreviewShapePainter({this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    if (shape == null) return;

    final paint = Paint()
      ..color = shape!.color
      ..strokeWidth = shape!.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = shape!.filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..isAntiAlias = true;

    switch (shape!.type) {
      case ShapeType.rectangle:
        _drawRectangle(canvas, shape!, paint);
        break;
      case ShapeType.circle:
        _drawCircle(canvas, shape!, paint);
        break;
      case ShapeType.arrow:
        _drawArrow(canvas, shape!, paint);
        break;
      case ShapeType.line:
        _drawLine(canvas, shape!, paint);
        break;
    }
  }

  void _drawRectangle(Canvas canvas, Shape shape, Paint paint) {
    final rect = Rect.fromPoints(shape.startPoint, shape.endPoint);
    canvas.drawRect(rect, paint);
  }

  void _drawCircle(Canvas canvas, Shape shape, Paint paint) {
    final rect = Rect.fromPoints(shape.startPoint, shape.endPoint);
    canvas.drawOval(rect, paint);
  }

  void _drawArrow(Canvas canvas, Shape shape, Paint paint) {
    final start = shape.startPoint;
    final end = shape.endPoint;

    canvas.drawLine(start, end, paint);

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final angle = math.atan2(dy, dx);

    final arrowSize = shape.strokeWidth * 4;
    const arrowAngle = math.pi / 6;

    final arrow1 = Offset(
      end.dx - arrowSize * math.cos(angle - arrowAngle),
      end.dy - arrowSize * math.sin(angle - arrowAngle),
    );
    final arrow2 = Offset(
      end.dx - arrowSize * math.cos(angle + arrowAngle),
      end.dy - arrowSize * math.sin(angle + arrowAngle),
    );

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrow1.dx, arrow1.dy)
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrow2.dx, arrow2.dy);

    canvas.drawPath(arrowPath, paint);
  }

  void _drawLine(Canvas canvas, Shape shape, Paint paint) {
    canvas.drawLine(shape.startPoint, shape.endPoint, paint);
  }

  @override
  bool shouldRepaint(PreviewShapePainter oldDelegate) {
    return shape != oldDelegate.shape;
  }
}
