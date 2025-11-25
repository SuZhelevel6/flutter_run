import 'package:flutter/material.dart';

/// 版本信息页
///
/// 显示应用版本和更新信息
class VersionInfoPage extends StatelessWidget {
  const VersionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('版本信息'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text('Flutter Run', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('Version 1.0.0+1', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
