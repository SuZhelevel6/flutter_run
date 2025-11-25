import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/l10n/l10n.dart';

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
          final currentLanguage = state.languageCode;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 语言选项容器
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      // 简体中文
                      _LanguageOption(
                        title: l10n.languageSimplifiedChinese,
                        languageCode: 'zh',
                        currentLanguageCode: currentLanguage ?? 'zh',  // 默认中文
                        themeColor: themeColor,
                        onTap: () {
                          cubit.setLanguage('zh');
                          _showSnackBar(context, l10n.languageChanged);
                        },
                      ),

                      const Divider(height: 1, indent: 16, endIndent: 16),

                      // English
                      _LanguageOption(
                        title: l10n.languageEnglish,
                        languageCode: 'en',
                        currentLanguageCode: currentLanguage ?? 'zh',  // 默认中文
                        themeColor: themeColor,
                        onTap: () {
                          cubit.setLanguage('en');
                          _showSnackBar(context, l10n.languageChanged);
                        },
                      ),
                    ],
                  ),
                ),
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

/// 语言选项组件
class _LanguageOption extends StatelessWidget {
  final String title;
  final String? languageCode;
  final String? currentLanguageCode;
  final Color themeColor;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.languageCode,
    required this.currentLanguageCode,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = languageCode == currentLanguageCode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(title),
              ),
              if (isSelected)
                Icon(Icons.check, size: 20, color: themeColor),
            ],
          ),
        ),
      ),
    );
  }
}
