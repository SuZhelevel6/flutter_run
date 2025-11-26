import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/widget_info.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Widget 详情页
///
/// 展示 Widget 的详细信息和示例
class WidgetDetailPage extends StatelessWidget {
  /// Widget 信息
  final WidgetInfo widgetInfo;

  const WidgetDetailPage({
    super.key,
    required this.widgetInfo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widgetInfo.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 组件信息卡片
            _InfoCard(widgetInfo: widgetInfo),

            const SizedBox(height: 24),

            // 预览区域
            _PreviewSection(
              title: l10n.widgetPreview,
              widgetInfo: widgetInfo,
            ),

            const SizedBox(height: 24),

            // 示例代码区域
            if (widgetInfo.sampleCode != null)
              _CodeSection(
                title: l10n.widgetSampleCode,
                code: widgetInfo.sampleCode!,
              ),
          ],
        ),
      ),
    );
  }
}

/// 信息卡片
class _InfoCard extends StatelessWidget {
  final WidgetInfo widgetInfo;

  const _InfoCard({required this.widgetInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 图标
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widgetInfo.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widgetInfo.icon,
                size: 48,
                color: widgetInfo.color,
              ),
            ),
            const SizedBox(height: 16),

            // 名称
            Text(
              widgetInfo.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // 分类标签
            Chip(
              label: Text(_getCategoryName(context, widgetInfo.category.id)),
              backgroundColor: widgetInfo.color.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: widgetInfo.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // 描述
            Text(
              widgetInfo.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(BuildContext context, String categoryId) {
    final l10n = AppLocalizations.of(context);
    switch (categoryId) {
      case 'stateless':
        return l10n.widgetCategoryStateless;
      case 'stateful':
        return l10n.widgetCategoryStateful;
      case 'other':
        return l10n.widgetCategoryOther;
      default:
        return categoryId;
    }
  }
}

/// 预览区域
class _PreviewSection extends StatelessWidget {
  final String title;
  final WidgetInfo widgetInfo;

  const _PreviewSection({
    required this.title,
    required this.widgetInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (widgetInfo.sampleWidget == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // 预览容器
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: widgetInfo.sampleWidget!,
            ),
          ),
        ),
      ],
    );
  }
}

/// 代码区域
class _CodeSection extends StatelessWidget {
  final String title;
  final String code;

  const _CodeSection({
    required this.title,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题和复制按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.codeCopied),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              tooltip: l10n.copyCode,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 代码容器
        Card(
          elevation: 2,
          color: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
