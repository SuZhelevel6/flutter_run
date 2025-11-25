import 'package:flutter/material.dart';

/// 语言设置页
///
/// 切换中文/English
class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('待实现 - 语言切换'),
      ),
    );
  }
}
