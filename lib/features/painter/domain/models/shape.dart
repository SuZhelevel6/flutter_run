import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// 形状类型枚举
enum ShapeType {
  /// 矩形
  rectangle,

  /// 圆形/椭圆
  circle,

  /// 箭头
  arrow,

  /// 直线
  line,
}

/// 形状模型
///
/// 表示一个几何形状，包含：
/// - 形状类型
/// - 起点和终点
/// - 样式属性
class Shape extends Equatable {
  /// 唯一标识符
  final String id;

  /// 形状类型
  final ShapeType type;

  /// 起始点
  final Offset startPoint;

  /// 结束点
  final Offset endPoint;

  /// 线条颜色
  final Color color;

  /// 线条粗细
  final double strokeWidth;

  /// 是否填充（仅对矩形和圆形有效）
  final bool filled;

  /// 创建时间
  final DateTime createdAt;

  const Shape({
    required this.id,
    required this.type,
    required this.startPoint,
    required this.endPoint,
    required this.color,
    required this.strokeWidth,
    this.filled = false,
    required this.createdAt,
  });

  /// 创建新形状的工厂方法
  factory Shape.create({
    required ShapeType type,
    required Offset startPoint,
    required Color color,
    required double strokeWidth,
    bool filled = false,
  }) {
    return Shape(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      startPoint: startPoint,
      endPoint: startPoint,
      color: color,
      strokeWidth: strokeWidth,
      filled: filled,
      createdAt: DateTime.now(),
    );
  }

  /// 更新结束点（拖拽过程中）
  Shape updateEndPoint(Offset newEndPoint) {
    return Shape(
      id: id,
      type: type,
      startPoint: startPoint,
      endPoint: newEndPoint,
      color: color,
      strokeWidth: strokeWidth,
      filled: filled,
      createdAt: createdAt,
    );
  }

  /// 形状是否有效（起点和终点不能相同）
  bool get isValid {
    const minDistance = 5.0;
    return (endPoint - startPoint).distance >= minDistance;
  }

  /// 获取形状的包围盒
  Rect get boundingBox {
    final left = startPoint.dx < endPoint.dx ? startPoint.dx : endPoint.dx;
    final top = startPoint.dy < endPoint.dy ? startPoint.dy : endPoint.dy;
    final right = startPoint.dx > endPoint.dx ? startPoint.dx : endPoint.dx;
    final bottom = startPoint.dy > endPoint.dy ? startPoint.dy : endPoint.dy;

    final halfWidth = strokeWidth / 2;
    return Rect.fromLTRB(
      left - halfWidth,
      top - halfWidth,
      right + halfWidth,
      bottom + halfWidth,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        startPoint,
        endPoint,
        color,
        strokeWidth,
        filled,
        createdAt,
      ];
}
