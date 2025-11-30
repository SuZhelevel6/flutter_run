import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/logging/app_logger.dart';
import '../../domain/models/shape.dart';
import '../../domain/models/stroke.dart';
import '../../domain/models/whiteboard_command.dart';
import '../../domain/models/whiteboard_tool.dart';
import 'whiteboard_state.dart';

/// 白板状态管理 Cubit
///
/// 管理白板的所有交互逻辑，包括：
/// - 工具切换
/// - 绑制操作（笔迹、形状）
/// - 橡皮擦
/// - 撤销/重做
/// - 清空画布
class WhiteboardCubit extends Cubit<WhiteboardState> {
  WhiteboardCubit() : super(const WhiteboardState());

  // ==================== 工具相关 ====================

  /// 选择工具
  void selectTool(WhiteboardTool tool) {
    AppLogger.debug('选择工具: ${tool.name}');
    emit(state.copyWith(
      currentTool: tool,
      // 切换工具时清除橡皮擦路径
      eraserPath: [],
    ));
  }

  /// 设置画笔颜色
  void setColor(Color color) {
    AppLogger.debug('设置颜色: $color');
    emit(state.copyWith(currentColor: color));
  }

  /// 设置画笔粗细
  void setStrokeWidth(double width) {
    AppLogger.debug('设置粗细: $width');
    emit(state.copyWith(currentStrokeWidth: width));
  }

  /// 设置橡皮擦大小
  void setEraserSize(double size) {
    AppLogger.debug('设置橡皮擦大小: $size');
    emit(state.copyWith(eraserSize: size));
  }

  // ==================== 绑制相关 ====================

  /// 开始绑制（手指按下）
  void startDrawing(Offset point) {
    if (state.currentTool.isDrawingTool) {
      // 画笔工具 - 创建新笔迹
      final stroke = Stroke.create(
        color: state.currentColor,
        strokeWidth: state.currentStrokeWidth,
        startPoint: point,
      );
      emit(state.copyWith(
        currentStroke: () => stroke,
        // 开始新绑制时清空重做栈
        redoStack: [],
      ));
    } else if (state.currentTool.isShapeTool) {
      // 形状工具 - 创建新形状
      final shapeType = _getShapeType(state.currentTool);
      final shape = Shape.create(
        type: shapeType,
        startPoint: point,
        color: state.currentColor,
        strokeWidth: state.currentStrokeWidth,
      );
      emit(state.copyWith(
        currentShape: () => shape,
        redoStack: [],
      ));
    } else if (state.currentTool.isEraser) {
      // 橡皮擦 - 开始记录擦除路径
      emit(state.copyWith(eraserPath: [point]));
    }
  }

  /// 继续绑制（手指移动）
  void continueDrawing(Offset point) {
    if (state.currentTool.isDrawingTool && state.currentStroke != null) {
      // 画笔工具 - 添加点
      final updatedStroke = state.currentStroke!.addPoint(point);
      emit(state.copyWith(currentStroke: () => updatedStroke));
    } else if (state.currentTool.isShapeTool && state.currentShape != null) {
      // 形状工具 - 更新结束点
      final updatedShape = state.currentShape!.updateEndPoint(point);
      emit(state.copyWith(currentShape: () => updatedShape));
    } else if (state.currentTool.isEraser) {
      // 橡皮擦 - 添加路径点并实时擦除
      final newPath = [...state.eraserPath, point];
      emit(state.copyWith(eraserPath: newPath));
      _performErase(newPath);
    }
  }

  /// 结束绑制（手指抬起）
  void endDrawing() {
    if (state.currentTool.isDrawingTool && state.currentStroke != null) {
      // 画笔工具 - 完成笔迹
      final stroke = state.currentStroke!;
      if (stroke.isValid) {
        final command = AddStrokeCommand(stroke);
        emit(state.copyWith(
          strokes: [...state.strokes, stroke],
          currentStroke: () => null,
          undoStack: [...state.undoStack, command],
        ));
        AppLogger.debug('完成笔迹: ${stroke.points.length} 个点');
      } else {
        // 笔迹无效（点太少），丢弃
        emit(state.copyWith(currentStroke: () => null));
      }
    } else if (state.currentTool.isShapeTool && state.currentShape != null) {
      // 形状工具 - 完成形状
      final shape = state.currentShape!;
      if (shape.isValid) {
        final command = AddShapeCommand(shape);
        emit(state.copyWith(
          shapes: [...state.shapes, shape],
          currentShape: () => null,
          undoStack: [...state.undoStack, command],
        ));
        AppLogger.debug('完成形状: ${shape.type.name}');
      } else {
        // 形状无效，丢弃
        emit(state.copyWith(currentShape: () => null));
      }
    } else if (state.currentTool.isEraser) {
      // 橡皮擦 - 结束擦除
      emit(state.copyWith(eraserPath: []));
    }
  }

  /// 取消绑制
  void cancelDrawing() {
    emit(state.copyWith(
      currentStroke: () => null,
      currentShape: () => null,
      eraserPath: [],
    ));
  }

  // ==================== 橡皮擦相关 ====================

  /// 执行擦除操作
  void _performErase(List<Offset> eraserPath) {
    final erasedStrokes = <Stroke>[];
    final remainingStrokes = <Stroke>[];

    // 检测与橡皮擦路径相交的笔迹
    for (final stroke in state.strokes) {
      if (_isStrokeIntersecting(stroke, eraserPath, state.eraserSize)) {
        erasedStrokes.add(stroke);
      } else {
        remainingStrokes.add(stroke);
      }
    }

    // 如果有笔迹被擦除
    if (erasedStrokes.isNotEmpty) {
      final command = EraseStrokesCommand(erasedStrokes);
      emit(state.copyWith(
        strokes: remainingStrokes,
        undoStack: [...state.undoStack, command],
      ));
      AppLogger.debug('擦除 ${erasedStrokes.length} 条笔迹');
    }
  }

  /// 检测笔迹是否与橡皮擦路径相交
  bool _isStrokeIntersecting(
    Stroke stroke,
    List<Offset> eraserPath,
    double eraserSize,
  ) {
    // 先用包围盒快速排除
    final strokeBox = stroke.boundingBox;
    final eraserBox = _getEraserBoundingBox(eraserPath, eraserSize);
    if (!strokeBox.overlaps(eraserBox)) {
      return false;
    }

    // 精确检测：点对点距离
    final halfEraserSize = eraserSize / 2;
    for (final strokePoint in stroke.points) {
      for (final eraserPoint in eraserPath) {
        if ((strokePoint - eraserPoint).distance < halfEraserSize) {
          return true;
        }
      }
    }
    return false;
  }

  /// 获取橡皮擦路径的包围盒
  Rect _getEraserBoundingBox(List<Offset> path, double size) {
    if (path.isEmpty) return Rect.zero;

    double minX = path.first.dx;
    double maxX = path.first.dx;
    double minY = path.first.dy;
    double maxY = path.first.dy;

    for (final point in path) {
      if (point.dx < minX) minX = point.dx;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dy > maxY) maxY = point.dy;
    }

    final halfSize = size / 2;
    return Rect.fromLTRB(
      minX - halfSize,
      minY - halfSize,
      maxX + halfSize,
      maxY + halfSize,
    );
  }

  // ==================== 撤销/重做 ====================

  /// 撤销
  void undo() {
    if (!state.canUndo) return;

    final command = state.undoStack.last;
    final newUndoStack = state.undoStack.sublist(0, state.undoStack.length - 1);
    final newRedoStack = [...state.redoStack, command];

    // 根据命令类型执行撤销
    if (command is AddStrokeCommand) {
      emit(state.copyWith(
        strokes: state.strokes.where((s) => s.id != command.stroke.id).toList(),
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    } else if (command is AddShapeCommand) {
      emit(state.copyWith(
        shapes: state.shapes.where((s) => s.id != command.shape.id).toList(),
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    } else if (command is EraseStrokesCommand) {
      emit(state.copyWith(
        strokes: [...state.strokes, ...command.erasedStrokes],
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    } else if (command is ClearCanvasCommand) {
      emit(state.copyWith(
        strokes: command.previousStrokes,
        shapes: command.previousShapes,
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    }

    AppLogger.debug('撤销: ${command.description}');
  }

  /// 重做
  void redo() {
    if (!state.canRedo) return;

    final command = state.redoStack.last;
    final newRedoStack = state.redoStack.sublist(0, state.redoStack.length - 1);
    final newUndoStack = [...state.undoStack, command];

    // 根据命令类型执行重做
    if (command is AddStrokeCommand) {
      emit(state.copyWith(
        strokes: [...state.strokes, command.stroke],
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    } else if (command is AddShapeCommand) {
      emit(state.copyWith(
        shapes: [...state.shapes, command.shape],
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    } else if (command is EraseStrokesCommand) {
      emit(state.copyWith(
        strokes: state.strokes
            .where(
                (s) => !command.erasedStrokes.any((erased) => erased.id == s.id))
            .toList(),
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    } else if (command is ClearCanvasCommand) {
      emit(state.copyWith(
        strokes: [],
        shapes: [],
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    }

    AppLogger.debug('重做: ${command.description}');
  }

  // ==================== 清空画布 ====================

  /// 清空画布
  void clearCanvas() {
    if (state.isEmpty) return;

    final command = ClearCanvasCommand(
      previousStrokes: state.strokes,
      previousShapes: state.shapes,
    );

    emit(state.copyWith(
      strokes: [],
      shapes: [],
      currentStroke: () => null,
      currentShape: () => null,
      undoStack: [...state.undoStack, command],
      redoStack: [],
    ));

    AppLogger.info('清空画布');
  }

  // ==================== 辅助方法 ====================

  /// 根据工具类型获取形状类型
  ShapeType _getShapeType(WhiteboardTool tool) {
    switch (tool) {
      case WhiteboardTool.rectangle:
        return ShapeType.rectangle;
      case WhiteboardTool.circle:
        return ShapeType.circle;
      case WhiteboardTool.arrow:
        return ShapeType.arrow;
      case WhiteboardTool.line:
        return ShapeType.line;
      default:
        return ShapeType.line;
    }
  }
}
