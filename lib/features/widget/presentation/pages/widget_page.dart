import 'package:flutter/material.dart';

/// Widget 展示页
///
/// 展示各种 Flutter Widget 的示例和用法
class WidgetPage extends StatelessWidget {
  const WidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget 展示'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.widgets_outlined, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Widget 展示页',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '待实现具体内容',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
