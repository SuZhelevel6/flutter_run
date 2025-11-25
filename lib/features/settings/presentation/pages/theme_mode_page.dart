import 'package:flutter/material.dart';

/// 主题模式设置页
///
/// 设置亮色/暗色/跟随系统
class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主题模式'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('待实现 - 主题模式切换'),
      ),
    );
  }
}
