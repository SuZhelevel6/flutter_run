/// Widget 分类枚举
///
/// 定义组件的分类类型
enum WidgetCategory {
  /// 无态组件 (Stateless Widget)
  stateless('stateless'),

  /// 有态组件 (Stateful Widget)
  stateful('stateful'),

  /// 其他组件
  other('other');

  /// 分类的唯一标识
  final String id;

  const WidgetCategory(this.id);

  /// 从 id 获取分类
  static WidgetCategory fromId(String id) {
    return WidgetCategory.values.firstWhere(
      (category) => category.id == id,
      orElse: () => WidgetCategory.other,
    );
  }
}
