import 'package:equatable/equatable.dart';

import 'shape.dart';
import 'stroke.dart';

/// 白板命令基类
///
/// 使用命令模式实现撤销/重做功能
/// 每个操作都封装为一个命令对象，支持执行和撤销
abstract class WhiteboardCommand extends Equatable {
  /// 命令创建时间
  final DateTime createdAt;

  WhiteboardCommand() : createdAt = DateTime.now();

  /// 命令描述（用于调试）
  String get description;

  @override
  List<Object?> get props => [createdAt];
}

/// 添加笔迹命令
class AddStrokeCommand extends WhiteboardCommand {
  final Stroke stroke;

  AddStrokeCommand(this.stroke);

  @override
  String get description => '添加笔迹: ${stroke.id}';

  @override
  List<Object?> get props => [stroke, ...super.props];
}

/// 添加形状命令
class AddShapeCommand extends WhiteboardCommand {
  final Shape shape;

  AddShapeCommand(this.shape);

  @override
  String get description => '添加形状: ${shape.type.name}';

  @override
  List<Object?> get props => [shape, ...super.props];
}

/// 删除笔迹命令（橡皮擦）
class EraseStrokesCommand extends WhiteboardCommand {
  /// 被删除的笔迹列表
  final List<Stroke> erasedStrokes;

  EraseStrokesCommand(this.erasedStrokes);

  @override
  String get description => '删除 ${erasedStrokes.length} 条笔迹';

  @override
  List<Object?> get props => [erasedStrokes, ...super.props];
}

/// 删除形状命令（橡皮擦）
class EraseShapesCommand extends WhiteboardCommand {
  /// 被删除的形状列表
  final List<Shape> erasedShapes;

  EraseShapesCommand(this.erasedShapes);

  @override
  String get description => '删除 ${erasedShapes.length} 个形状';

  @override
  List<Object?> get props => [erasedShapes, ...super.props];
}

/// 清空画布命令
class ClearCanvasCommand extends WhiteboardCommand {
  /// 清空前的所有笔迹
  final List<Stroke> previousStrokes;

  /// 清空前的所有形状
  final List<Shape> previousShapes;

  ClearCanvasCommand({
    required this.previousStrokes,
    required this.previousShapes,
  });

  @override
  String get description =>
      '清空画布: ${previousStrokes.length} 笔迹, ${previousShapes.length} 形状';

  @override
  List<Object?> get props => [previousStrokes, previousShapes, ...super.props];
}

/// 复合命令（批量操作）
class CompositeCommand extends WhiteboardCommand {
  final List<WhiteboardCommand> commands;

  CompositeCommand(this.commands);

  @override
  String get description => '复合命令: ${commands.length} 个操作';

  @override
  List<Object?> get props => [commands, ...super.props];
}
