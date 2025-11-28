import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/l10n/l10n.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_option_tile.dart';

/// 语言设置页
///
/// 切换中文/English
class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettingsTitle),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: BlocBuilder<SettingsCubit, dynamic>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          final currentLanguage = state.languageCode ?? 'zh';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 语言选项
              SettingsSection(
                children: [
                  SettingsOptionTile(
                    title: l10n.languageSimplifiedChinese,
                    isSelected: currentLanguage == 'zh',
                    checkColor: themeColor,
                    onTap: () {
                      cubit.setLanguage('zh');
                      _showSnackBar(context, l10n.languageChanged);
                    },
                  ),
                  SettingsOptionTile(
                    title: l10n.languageEnglish,
                    isSelected: currentLanguage == 'en',
                    checkColor: themeColor,
                    onTap: () {
                      cubit.setLanguage('en');
                      _showSnackBar(context, l10n.languageChanged);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
