import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

/// 国际化导出文件
///
/// 统一导出所有国际化相关类
export 'app_localizations.dart';
export 'app_localizations_zh.dart';
export 'app_localizations_en.dart';

/// BuildContext 扩展，便捷获取国际化文本
extension LocalizationExtension on BuildContext {
  /// 获取国际化实例
  AppLocalizations get l10n => AppLocalizations.of(this);
}
