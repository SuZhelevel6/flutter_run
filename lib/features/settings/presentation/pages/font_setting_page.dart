import 'package:flutter/material.dart';

/// 字体设置页
///
/// 调整字体大小
class FontSettingPage extends StatelessWidget {
  const FontSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字体设置'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('待实现 - 字体大小设置'),
      ),
    );
  }
}
