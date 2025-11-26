import 'package:flutter/material.dart';
import '../domain/models/widget_category.dart';
import '../domain/models/widget_info.dart';

/// Mock 数据 - Widget 集合
///
/// 提供组件集录的模拟数据
class MockWidgetData {
  MockWidgetData._();

  /// 所有组件列表
  static final List<WidgetInfo> allWidgets = [
    // ==================== Stateless 组件 ====================
    WidgetInfo(
      name: 'Container',
      category: WidgetCategory.stateless,
      description: '一个组合了常见的绘制、定位、尺寸等功能的便捷组件',
      icon: Icons.crop_square,
      color: Colors.blue.shade400,
      sampleCode: '''Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text('Container'),
)''',
      sampleWidget: Container(
        width: 200,
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Container',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
    WidgetInfo(
      name: 'Text',
      category: WidgetCategory.stateless,
      description: '显示文本内容的基础组件，支持多种样式和对齐方式',
      icon: Icons.text_fields,
      color: Colors.green.shade400,
      sampleCode: '''Text(
  'Hello Flutter',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  ),
)''',
      sampleWidget: const Text(
        'Hello Flutter',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    ),

    // ==================== Stateful 组件 ====================
    WidgetInfo(
      name: 'Checkbox',
      category: WidgetCategory.stateful,
      description: '复选框组件，用于选择多个选项',
      icon: Icons.check_box,
      color: Colors.orange.shade400,
      sampleCode: '''bool _checked = false;

Checkbox(
  value: _checked,
  onChanged: (value) {
    setState(() {
      _checked = value ?? false;
    });
  },
)''',
      sampleWidget: const _CheckboxExample(),
    ),
    WidgetInfo(
      name: 'Switch',
      category: WidgetCategory.stateful,
      description: '开关组件，用于切换开/关状态',
      icon: Icons.toggle_on,
      color: Colors.purple.shade400,
      sampleCode: '''bool _switched = false;

Switch(
  value: _switched,
  onChanged: (value) {
    setState(() {
      _switched = value;
    });
  },
)''',
      sampleWidget: const _SwitchExample(),
    ),

    // ==================== Other 组件 ====================
    WidgetInfo(
      name: 'Padding',
      category: WidgetCategory.other,
      description: '为子组件添加内边距的布局组件',
      icon: Icons.space_bar,
      color: Colors.teal.shade400,
      sampleCode: '''Padding(
  padding: EdgeInsets.all(16.0),
  child: Text('Padding Example'),
)''',
      sampleWidget: Container(
        color: Colors.grey.shade200,
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Padding',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
    WidgetInfo(
      name: 'Center',
      category: WidgetCategory.other,
      description: '将子组件居中显示的布局组件',
      icon: Icons.center_focus_strong,
      color: Colors.pink.shade400,
      sampleCode: '''Center(
  child: Text('Center Example'),
)''',
      sampleWidget: Container(
        width: 200,
        height: 100,
        color: Colors.grey.shade200,
        child: const Center(
          child: Text(
            'Center',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
  ];

  /// 根据分类获取组件列表
  static List<WidgetInfo> getWidgetsByCategory(WidgetCategory category) {
    return allWidgets.where((widget) => widget.category == category).toList();
  }

  /// 获取所有分类
  static List<WidgetCategory> getAllCategories() {
    return WidgetCategory.values;
  }
}

// ==================== 示例组件 ====================

/// Checkbox 示例组件
class _CheckboxExample extends StatefulWidget {
  const _CheckboxExample();

  @override
  State<_CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<_CheckboxExample> {
  bool _checked = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _checked,
          onChanged: (value) {
            setState(() {
              _checked = value ?? false;
            });
          },
        ),
        const Text('Checkbox'),
      ],
    );
  }
}

/// Switch 示例组件
class _SwitchExample extends StatefulWidget {
  const _SwitchExample();

  @override
  State<_SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<_SwitchExample> {
  bool _switched = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: _switched,
          onChanged: (value) {
            setState(() {
              _switched = value;
            });
          },
        ),
        const Text('Switch'),
      ],
    );
  }
}
