import 'package:flutter/material.dart';

/// Knowledge 知识页
///
/// 展示 Flutter 知识点和学习资料
class KnowledgePage extends StatelessWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.purple),
            SizedBox(height: 16),
            Text(
              'Knowledge 知识页',
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
