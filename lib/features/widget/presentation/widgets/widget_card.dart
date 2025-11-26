import 'package:flutter/material.dart';
import '../../domain/models/widget_info.dart';

/// Widget 卡片组件
///
/// 展示单个 Widget 的卡片视图
class WidgetCard extends StatelessWidget {
  /// Widget 信息
  final WidgetInfo widgetInfo;

  /// 点击回调
  final VoidCallback? onTap;

  const WidgetCard({
    super.key,
    required this.widgetInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部颜色条
            Container(
              height: 8,
              color: widgetInfo.color,
            ),

            // 内容区域
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 图标
                    Icon(
                      widgetInfo.icon,
                      size: 48,
                      color: widgetInfo.color,
                    ),
                    const SizedBox(height: 12),

                    // 名称
                    Text(
                      widgetInfo.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // 描述
                    Expanded(
                      child: Text(
                        widgetInfo.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
