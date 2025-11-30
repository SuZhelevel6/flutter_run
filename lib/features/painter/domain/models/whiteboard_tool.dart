/// 白板工具枚举
///
/// 定义白板支持的所有工具类型
enum WhiteboardTool {
  /// 画笔工具 - 自由绘制
  pen,

  /// 橡皮擦工具 - 擦除笔迹
  eraser,

  /// 矩形工具
  rectangle,

  /// 圆形工具
  circle,

  /// 箭头工具
  arrow,

  /// 直线工具
  line,
}

/// WhiteboardTool 扩展方法
extension WhiteboardToolExtension on WhiteboardTool {
  /// 是否为绘制工具（画笔）
  bool get isDrawingTool => this == WhiteboardTool.pen;

  /// 是否为形状工具
  bool get isShapeTool => [
        WhiteboardTool.rectangle,
        WhiteboardTool.circle,
        WhiteboardTool.arrow,
        WhiteboardTool.line,
      ].contains(this);

  /// 是否为橡皮擦
  bool get isEraser => this == WhiteboardTool.eraser;
}
