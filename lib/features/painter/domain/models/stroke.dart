import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// 笔迹模型
///
/// 表示一条完整的手绘笔迹，包含：
/// - 所有采样点
/// - 颜色和粗细
/// - 唯一标识符
class Stroke extends Equatable {
  /// 唯一标识符
  final String id;

  /// 笔迹包含的所有点
  final List<Offset> points;

  /// 笔迹颜色
  final Color color;

  /// 笔迹粗细
  final double strokeWidth;

  /// 创建时间
  final DateTime createdAt;

  const Stroke({
    required this.id,
    required this.points,
    required this.color,
    required this.strokeWidth,
    required this.createdAt,
  });

  /// 创建新笔迹的工厂方法
  factory Stroke.create({
    required Color color,
    required double strokeWidth,
    Offset? startPoint,
  }) {
    return Stroke(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      points: startPoint != null ? [startPoint] : [],
      color: color,
      strokeWidth: strokeWidth,
      createdAt: DateTime.now(),
    );
  }

  /// 添加新的点
  Stroke addPoint(Offset point) {
    return Stroke(
      id: id,
      points: [...points, point],
      color: color,
      strokeWidth: strokeWidth,
      createdAt: createdAt,
    );
  }

  /// 笔迹是否有效（至少包含2个点才能绘制）
  bool get isValid => points.length >= 2;

  /// 笔迹是否为空
  bool get isEmpty => points.isEmpty;

  /// 获取笔迹的包围盒（用于橡皮擦检测优化）
  Rect get boundingBox {
    if (points.isEmpty) return Rect.zero;

    double minX = points.first.dx;
    double maxX = points.first.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;

    for (final point in points) {
      if (point.dx < minX) minX = point.dx;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dy > maxY) maxY = point.dy;
    }

    // 考虑笔迹粗细
    final halfWidth = strokeWidth / 2;
    return Rect.fromLTRB(
      minX - halfWidth,
      minY - halfWidth,
      maxX + halfWidth,
      maxY + halfWidth,
    );
  }

  @override
  List<Object?> get props => [id, points, color, strokeWidth, createdAt];
}
