import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../cubit/whiteboard_cubit.dart';
import '../cubit/whiteboard_state.dart';

/// 线条粗细选择器
///
/// 显示预设粗细选项，支持选择画笔粗细
class StrokeWidthPicker extends StatelessWidget {
  const StrokeWidthPicker({super.key});

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
      child: BlocBuilder<WhiteboardCubit, WhiteboardState>(
        buildWhen: (prev, curr) =>
            prev.currentStrokeWidth != curr.currentStrokeWidth ||
            prev.currentColor != curr.currentColor,
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: WhiteboardState.presetStrokeWidths.map((width) {
              return _StrokeWidthButton(
                width: width,
                color: state.currentColor,
                isSelected: state.currentStrokeWidth == width,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

/// 粗细按钮
class _StrokeWidthButton extends StatelessWidget {
  final double width;
  final Color color;
  final bool isSelected;

  const _StrokeWidthButton({
    required this.width,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: '${width.toInt()}px',
        child: Material(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => context.read<WhiteboardCubit>().setStrokeWidth(width),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              child: Container(
                width: width + 8,
                height: width + 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: color == Colors.white
                      ? Border.all(color: colorScheme.outline, width: 1)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 迷你粗细选择器（带滑块）
class MiniStrokeWidthPicker extends StatelessWidget {
  const MiniStrokeWidthPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhiteboardCubit, WhiteboardState>(
      buildWhen: (prev, curr) =>
          prev.currentStrokeWidth != curr.currentStrokeWidth ||
          prev.currentColor != curr.currentColor,
      builder: (context, state) {
        return PopupMenuButton<double>(
          offset: const Offset(0, -150),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tooltip: context.l10n.painterStrokeWidth,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: state.currentStrokeWidth + 4,
              height: state.currentStrokeWidth + 4,
              decoration: BoxDecoration(
                color: state.currentColor,
                shape: BoxShape.circle,
                border: state.currentColor == Colors.white
                    ? Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      )
                    : null,
              ),
            ),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem<double>(
                enabled: false,
                child: SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.painterStrokeWidthValue(state.currentStrokeWidth.toInt()),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Slider(
                            value: state.currentStrokeWidth,
                            min: 1.0,
                            max: 20.0,
                            divisions: 19,
                            label: '${state.currentStrokeWidth.toInt()}px',
                            onChanged: (value) {
                              context
                                  .read<WhiteboardCubit>()
                                  .setStrokeWidth(value);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: WhiteboardState.presetStrokeWidths.map((w) {
                          final isSelected = state.currentStrokeWidth == w;
                          return GestureDetector(
                            onTap: () {
                              context.read<WhiteboardCubit>().setStrokeWidth(w);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                width: w + 4,
                                height: w + 4,
                                decoration: BoxDecoration(
                                  color: state.currentColor,
                                  shape: BoxShape.circle,
                                  border: state.currentColor == Colors.white
                                      ? Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          width: 1,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
