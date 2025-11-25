import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';

/// 语言设置页
///
/// 切换中文/English
class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置'),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, dynamic>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          final currentLanguage = state.languageCode;

          return ListView(
            children: [
              const SizedBox(height: 16),
              _LanguageOption(
                title: '跟随系统',
                subtitle: '使用系统语言设置',
                languageCode: null,
                currentLanguageCode: currentLanguage,
                onTap: () => cubit.setLanguage(null),
              ),
              _LanguageOption(
                title: '简体中文',
                subtitle: 'Simplified Chinese',
                languageCode: 'zh',
                currentLanguageCode: currentLanguage,
                onTap: () => cubit.setLanguage('zh'),
              ),
              _LanguageOption(
                title: 'English',
                subtitle: 'English',
                languageCode: 'en',
                currentLanguageCode: currentLanguage,
                onTap: () => cubit.setLanguage('en'),
              ),
              const Divider(height: 32),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '注意：语言切换功能需要配合国际化(i18n)使用。当���版本暂未完全支持多语言。',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 语言选项组件
class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? languageCode;
  final String? currentLanguageCode;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.languageCode,
    required this.currentLanguageCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = languageCode == currentLanguageCode;

    return ListTile(
      leading: Icon(
        Icons.language,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      subtitle: Text(subtitle),
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
