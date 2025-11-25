import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../../core/l10n/l10n.dart';

/// 版本信息页
///
/// 显示应用版本和更新信息
class VersionInfoPage extends StatelessWidget {
  const VersionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.versionInfoTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 32),
          // 应用图标和名称
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Flutter Run',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Version 1.0.0+1',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // 应用信息
          _InfoCard(
            title: '应用信息',
            items: [
              _InfoItem(label: '应用名称', value: 'Flutter Run'),
              _InfoItem(label: '版本号', value: '1.0.0'),
              _InfoItem(label: '构建号', value: '1'),
              _InfoItem(label: '构建模式', value: kDebugMode ? 'Debug' : 'Release'),
            ],
          ),
          const SizedBox(height: 16),

          // 系统信息
          _InfoCard(
            title: '系统信息',
            items: [
              _InfoItem(
                label: '操作系统',
                value: _getOSInfo(),
              ),
              _InfoItem(
                label: 'Flutter 版本',
                value: 'SDK 3.9.0+',
              ),
              _InfoItem(
                label: 'Dart 版本',
                value: 'SDK 3.9.0+',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 关于信息
          _InfoCard(
            title: '关于',
            items: [
              _InfoItem(
                label: '描述',
                value: '一个基于 Clean Architecture 的 Flutter 应用示例',
              ),
              _InfoItem(
                label: '开发者',
                value: 'Flutter Run Team',
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 版权信息
          Center(
            child: Text(
              '© 2024 Flutter Run\nAll rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// 获取操作系统信息
  String _getOSInfo() {
    if (kIsWeb) {
      return 'Web';
    } else {
      return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    }
  }
}

/// 信息卡片
class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoCard({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

/// 信息项
class _InfoItem {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });
}
