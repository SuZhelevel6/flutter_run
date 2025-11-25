import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/logging/talker_config.dart';

/// 日志查看器页面
///
/// 显示应用日志，支持筛选和导出
/// 使用自定义 Scaffold 包装 TalkerScreen，添加顶部间距
class LogViewerPage extends StatelessWidget {
  const LogViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 添加顶部间距，避免与左侧导航栏底部按钮重叠
          const SizedBox(height: 48),
          // 使用 Expanded 让 TalkerScreen 占据剩余空间
          Expanded(
            child: TalkerScreen(
              talker: TalkerConfig.instance,
              appBarTitle: 'Flutter Run 日志',
            ),
          ),
        ],
      ),
    );
  }
}
