import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/l10n/l10n.dart';

/// 主题色设置页
///
/// 参考 FlutterPlay: ThemeColorPage
/// 使用网格布局展示所有可用的主题色
/// 点击可切换主题色
class ThemeColorPage extends StatelessWidget {
  const ThemeColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.themeColorTitle),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: BlocBuilder<SettingsCubit, dynamic>(
        builder: (context, state) {
          final currentColor = state.themeColor;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
            ),
            itemCount: _ThemeColorType.values.length,
            itemBuilder: (context, index) {
              final colorType = _ThemeColorType.values[index];
              final isSelected = colorType.color.value == currentColor.value;

              return _ThemeColorCell(
                colorType: colorType,
                isSelected: isSelected,
                onTap: () {
                  context.read<SettingsCubit>().setThemeColor(colorType.color);
                  // 延迟返回以便用户看到选中效果
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// 主题色单元格组件
class _ThemeColorCell extends StatelessWidget {
  final _ThemeColorType colorType;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeColorCell({
    required this.colorType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorType.color;
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.shade50,
                color.shade100,
                color.shade200,
                color.shade300,
                color.shade400,
                color.shade500,
                color.shade600,
                color.shade700,
                color.shade800,
                color.shade900,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 顶部标题栏
              Container(
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: isSelected
                      ? Colors.blue.withAlpha(128)
                      : Colors.grey.withAlpha(77),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      colorType.colorHex,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
              // 中间文字
              Center(
                child: Text(
                  colorType.label(l10n),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 主题色类型枚举
///
/// 参考 FlutterPlay 的 ThemeColorType
enum _ThemeColorType {
  red(Colors.red),
  orange(Colors.orange),
  yellow(Colors.yellow),
  green(Colors.green),
  blue(Colors.blue),
  indigo(Colors.indigo),
  purple(Colors.purple),
  deepPurple(Colors.deepPurple),
  teal(Colors.teal),
  cyan(Colors.cyan);

  final MaterialColor color;

  const _ThemeColorType(this.color);

  /// 获取本地化标签
  String label(AppLocalizations l10n) {
    return switch (this) {
      _ThemeColorType.red => l10n.themeColorRed,
      _ThemeColorType.orange => l10n.themeColorOrange,
      _ThemeColorType.yellow => l10n.themeColorYellow,
      _ThemeColorType.green => l10n.themeColorGreen,
      _ThemeColorType.blue => l10n.themeColorBlue,
      _ThemeColorType.indigo => l10n.themeColorIndigo,
      _ThemeColorType.purple => l10n.themeColorPurple,
      _ThemeColorType.deepPurple => l10n.themeColorDeepPurple,
      _ThemeColorType.teal => l10n.themeColorTeal,
      _ThemeColorType.cyan => l10n.themeColorCyan,
    };
  }

  /// 获取色值字符串 (用于显示)
  String get colorHex {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}
