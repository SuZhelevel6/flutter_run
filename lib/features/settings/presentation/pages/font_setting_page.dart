import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/l10n/l10n.dart';

/// 字体设置页
///
/// 调整字体大小
class FontSettingPage extends StatelessWidget {
  const FontSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fontSettingsTitle),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, dynamic>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          final fontScale = state.fontScale;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 预览文本
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.previewText,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.previewTextContent,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 字体大小滑块
              Text(
                l10n.fontScale,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('小'),
                  Expanded(
                    child: Slider(
                      value: fontScale,
                      min: 0.8,
                      max: 1.5,
                      divisions: 14,
                      label: '${(fontScale * 100).toInt()}%',
                      onChanged: (value) => cubit.setFontScale(value),
                    ),
                  ),
                  const Text('大'),
                ],
              ),
              Center(
                child: Text(
                  '当前: ${(fontScale * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 24),

              // 预设大小选项
              Text(
                '预设大小',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _FontScaleOption(
                title: '小',
                scale: 0.9,
                currentScale: fontScale,
                onTap: () => cubit.setFontScale(0.9),
              ),
              _FontScaleOption(
                title: '标准',
                scale: 1.0,
                currentScale: fontScale,
                onTap: () => cubit.setFontScale(1.0),
              ),
              _FontScaleOption(
                title: '中',
                scale: 1.1,
                currentScale: fontScale,
                onTap: () => cubit.setFontScale(1.1),
              ),
              _FontScaleOption(
                title: '大',
                scale: 1.2,
                currentScale: fontScale,
                onTap: () => cubit.setFontScale(1.2),
              ),
              _FontScaleOption(
                title: '特大',
                scale: 1.3,
                currentScale: fontScale,
                onTap: () => cubit.setFontScale(1.3),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 字体缩放选项组件
class _FontScaleOption extends StatelessWidget {
  final String title;
  final double scale;
  final double currentScale;
  final VoidCallback onTap;

  const _FontScaleOption({
    required this.title,
    required this.scale,
    required this.currentScale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = (scale - currentScale).abs() < 0.01;

    return ListTile(
      title: Text(title),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
            )
          : null,
      onTap: onTap,
    );
  }
}
