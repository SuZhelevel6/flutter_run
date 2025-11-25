import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';

/// 主题色设置页
///
/// 选择应用主题颜色
class ThemeColorPage extends StatelessWidget {
  const ThemeColorPage({super.key});

  /// 预设的主题色列表
  static const List<Color> _presetColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主题色'),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, dynamic>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          final currentColor = state.themeColor;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _presetColors.length,
            itemBuilder: (context, index) {
              final color = _presetColors[index];
              final isSelected = color.toARGB32() == currentColor.toARGB32();

              return _ColorOption(
                color: color,
                isSelected: isSelected,
                onTap: () => cubit.setThemeColor(color),
              );
            },
          );
        },
      ),
    );
  }
}

/// 颜色选项组件
class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 4,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isSelected
            ? const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 32,
                ),
              )
            : null,
      ),
    );
  }
}
