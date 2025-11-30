import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/models/shape.dart';
import '../../domain/models/stroke.dart';
import '../../domain/models/whiteboard_command.dart';
import '../../domain/models/whiteboard_tool.dart';

/// 白板状态
///
/// 管理白板的所有状态，包括：
/// - 当前工具
/// - 画笔属性（颜色、粗细）
/// - 已绘制的笔迹和形状
/// - 正在绘制的临时笔迹/形状
/// - 撤销/重做栈
class WhiteboardState extends Equatable {
  /// 当前选中的工具
  final WhiteboardTool currentTool;

  /// 当前画笔颜色
  final Color currentColor;

  /// 当前画笔粗细
  final double currentStrokeWidth;

  /// 已完成的笔迹列表
  final List<Stroke> strokes;

  /// 已完成的形状列表
  final List<Shape> shapes;

  /// 正在绘制的笔迹（预览）
  final Stroke? currentStroke;

  /// 正在绘制的形状（预览）
  final Shape? currentShape;

  /// 撤销栈
  final List<WhiteboardCommand> undoStack;

  /// 重做栈
  final List<WhiteboardCommand> redoStack;

  /// 橡皮擦路径（用于实时显示擦除轨迹）
  final List<Offset> eraserPath;

  /// 橡皮擦大小
  final double eraserSize;

  /// 预设颜色列表
  static const List<Color> presetColors = [
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.white,
  ];

  /// 预设粗细列表
  static const List<double> presetStrokeWidths = [2.0, 4.0, 8.0, 12.0];

  const WhiteboardState({
    this.currentTool = WhiteboardTool.pen,
    this.currentColor = Colors.black,
    this.currentStrokeWidth = 4.0,
    this.strokes = const [],
    this.shapes = const [],
    this.currentStroke,
    this.currentShape,
    this.undoStack = const [],
    this.redoStack = const [],
    this.eraserPath = const [],
    this.eraserSize = 20.0,
  });

  /// 是否可以撤销
  bool get canUndo => undoStack.isNotEmpty;

  /// 是否可以重做
  bool get canRedo => redoStack.isNotEmpty;

  /// 画布是否为空
  bool get isEmpty => strokes.isEmpty && shapes.isEmpty;

  /// 是否正在绘制
  bool get isDrawing => currentStroke != null || currentShape != null;

  /// 创建副本
  WhiteboardState copyWith({
    WhiteboardTool? currentTool,
    Color? currentColor,
    double? currentStrokeWidth,
    List<Stroke>? strokes,
    List<Shape>? shapes,
    Stroke? Function()? currentStroke,
    Shape? Function()? currentShape,
    List<WhiteboardCommand>? undoStack,
    List<WhiteboardCommand>? redoStack,
    List<Offset>? eraserPath,
    double? eraserSize,
  }) {
    return WhiteboardState(
      currentTool: currentTool ?? this.currentTool,
      currentColor: currentColor ?? this.currentColor,
      currentStrokeWidth: currentStrokeWidth ?? this.currentStrokeWidth,
      strokes: strokes ?? this.strokes,
      shapes: shapes ?? this.shapes,
      currentStroke:
          currentStroke != null ? currentStroke() : this.currentStroke,
      currentShape: currentShape != null ? currentShape() : this.currentShape,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
      eraserPath: eraserPath ?? this.eraserPath,
      eraserSize: eraserSize ?? this.eraserSize,
    );
  }

  @override
  List<Object?> get props => [
        currentTool,
        currentColor,
        currentStrokeWidth,
        strokes,
        shapes,
        currentStroke,
        currentShape,
        undoStack,
        redoStack,
        eraserPath,
        eraserSize,
      ];
}
