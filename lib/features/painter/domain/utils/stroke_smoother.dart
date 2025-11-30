import 'dart:ui';

/// 笔迹平滑处理工具
///
/// 使用二次贝塞尔曲线将离散的触摸点平滑连接
/// 解决原始触摸点直接连线产生的锯齿问题
class StrokeSmoother {
  /// 将原始点列表转换为平滑路径
  ///
  /// 算法原理：
  /// 1. 两点情况：直接连线
  /// 2. 多点情况：使用二次贝塞尔曲线
  ///    - 控制点：当前点
  ///    - 终点：当前点与下一点的中点
  ///    - 这样保证曲线经过所有中点，实现平滑过渡
  static Path smoothPath(List<Offset> points) {
    if (points.isEmpty) return Path();

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    if (points.length == 1) {
      // 单点情况：画一个小圆点
      return path;
    }

    if (points.length == 2) {
      // 两点情况：直接连线
      path.lineTo(points[1].dx, points[1].dy);
      return path;
    }

    // 多点情况：使用二次贝塞尔曲线
    for (int i = 1; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      // 计算中点作为曲线终点
      final midPoint = Offset(
        (p1.dx + p2.dx) / 2,
        (p1.dy + p2.dy) / 2,
      );

      // 使用当前点作为控制点，中点作为终点
      path.quadraticBezierTo(p1.dx, p1.dy, midPoint.dx, midPoint.dy);
    }

    // 连接到最后一个点
    final lastPoint = points.last;
    path.lineTo(lastPoint.dx, lastPoint.dy);

    return path;
  }

  /// 使用三次贝塞尔曲线平滑（更平滑但计算量更大）
  ///
  /// 适用于需要更高质量曲线的场景
  static Path smoothPathCubic(List<Offset> points) {
    if (points.length < 4) {
      return smoothPath(points);
    }

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 3; i += 3) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final p2 = points[i + 2];
      final p3 = points[i + 3];

      // 计算控制点
      final cp1 = Offset(
        p0.dx + (p1.dx - p0.dx) * 0.5,
        p0.dy + (p1.dy - p0.dy) * 0.5,
      );
      final cp2 = Offset(
        p3.dx - (p3.dx - p2.dx) * 0.5,
        p3.dy - (p3.dy - p2.dy) * 0.5,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p3.dx, p3.dy);
    }

    // 处理剩余的点
    final remaining = points.length % 3;
    if (remaining > 0) {
      for (int i = points.length - remaining; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    return path;
  }

  /// 对点列表进行采样优化
  ///
  /// 当点过于密集时，移除过近的点以提高性能
  /// [minDistance] 两点之间的最小距离
  static List<Offset> downsample(List<Offset> points, {double minDistance = 2.0}) {
    if (points.length < 3) return points;

    final result = <Offset>[points.first];

    for (int i = 1; i < points.length - 1; i++) {
      final distance = (points[i] - result.last).distance;
      if (distance >= minDistance) {
        result.add(points[i]);
      }
    }

    // 始终保留最后一个点
    result.add(points.last);

    return result;
  }

  /// 插值补点
  ///
  /// 当两点距离过大时（快速滑动），在中间插入点以保持曲线连续
  /// [maxDistance] 两点之间的最大允许距离
  static List<Offset> interpolate(List<Offset> points, {double maxDistance = 20.0}) {
    if (points.length < 2) return points;

    final result = <Offset>[points.first];

    for (int i = 1; i < points.length; i++) {
      final prev = result.last;
      final current = points[i];
      final distance = (current - prev).distance;

      if (distance > maxDistance) {
        // 需要插入中间点
        final numPoints = (distance / maxDistance).ceil();
        for (int j = 1; j < numPoints; j++) {
          final t = j / numPoints;
          result.add(Offset.lerp(prev, current, t)!);
        }
      }

      result.add(current);
    }

    return result;
  }
}
