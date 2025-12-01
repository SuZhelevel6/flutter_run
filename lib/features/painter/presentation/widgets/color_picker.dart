import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../cubit/whiteboard_cubit.dart';
import '../cubit/whiteboard_state.dart';

/// 颜色选择器
///
/// 显示预设颜色列表，支持选择画笔颜色
class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocSelector<WhiteboardCubit, WhiteboardState, Color>(
        selector: (state) => state.currentColor,
        builder: (context, currentColor) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 颜色指示器
              _ColorIndicator(color: currentColor),
              const SizedBox(width: 8),
              // 预设颜色
              ...WhiteboardState.presetColors.map((color) {
                return _ColorButton(
                  color: color,
                  isSelected: currentColor == color,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

/// 当前颜色指示器
class _ColorIndicator extends StatelessWidget {
  final Color color;

  const _ColorIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

/// 颜色按钮
class _ColorButton extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ColorButton({
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.read<WhiteboardCubit>().setColor(color),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : (color == Colors.white
                        ? Theme.of(context).colorScheme.outline
                        : Colors.transparent),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color:
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// 迷你颜色选择器（用于底部栏）
class MiniColorPicker extends StatelessWidget {
  const MiniColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WhiteboardCubit, WhiteboardState, Color>(
      selector: (state) => state.currentColor,
      builder: (context, currentColor) {
        return PopupMenuButton<Color>(
          offset: const Offset(0, -200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tooltip: context.l10n.painterSelectColor,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem<Color>(
                enabled: false,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: WhiteboardState.presetColors.map((color) {
                    final isSelected = currentColor == color;
                    return GestureDetector(
                      onTap: () {
                        context.read<WhiteboardCubit>().setColor(color);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : (color == Colors.white
                                    ? Theme.of(context).colorScheme.outline
                                    : Colors.transparent),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
