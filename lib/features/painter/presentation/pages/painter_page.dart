import 'package:flutter/material.dart';

/// Painter 画板页
///
/// 展示 CustomPainter 绘图示例
class PainterPage extends StatelessWidget {
  const PainterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painter'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.brush_outlined, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Painter 画板页',
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
