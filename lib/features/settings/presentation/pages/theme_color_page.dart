import 'package:flutter/material.dart';

/// 主题色设置页
///
/// 选择应用主题颜色
class ThemeColorPage extends StatelessWidget {
  const ThemeColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主题色'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('待实现 - 主题色选择'),
      ),
    );
  }
}
