import 'app_localizations.dart';

/// 简体中文国际化
class AppLocalizationsZh extends AppLocalizations {
  const AppLocalizationsZh();

  @override
  String get languageCode => 'zh';

  // ==================== 导航栏 ====================
  @override
  String get navWidget => '组件集录';

  @override
  String get navBlog => '博客文章';

  @override
  String get navPainter => '绘制集录';

  @override
  String get navKnowledge => '知识集锦';

  @override
  String get navTools => '工具宝箱';

  @override
  String get navAccount => '应用信息';

  // ==================== 设置页面 ====================
  @override
  String get settings => '设置';

  @override
  String get darkMode => '深色模式';

  @override
  String get themeColor => '主题色';

  @override
  String get fontSettings => '字体设置';

  @override
  String get languageSettings => '语言设置';

  @override
  String get versionInfo => '版本信息';

  @override
  String get logViewer => '日志查看器';

  // ==================== 主题模式 ====================
  @override
  String get themeModeTitle => '深色模式';

  @override
  String get followSystem => '跟随系统';

  @override
  String get followSystemDesc => '自动根据系统设置切换主题';

  @override
  String get manualSettings => '手动设置';

  @override
  String get lightMode => '浅色模式';

  @override
  String get darkModeOption => '深色模式';

  @override
  String get themeModeChanged => '主题模式已切换';

  @override
  String get followSystemEnabled => '已启用跟随系统';

  @override
  String get followSystemDisabled => '已关闭跟随系统';

  @override
  String get lightModeEnabled => '已切换到浅色模式';

  @override
  String get darkModeEnabled => '已切换到深色模式';

  // ==================== 主题色 ====================
  @override
  String get themeColorTitle => '主题色';

  @override
  String get currentThemeColor => '当前主题色';

  @override
  String get presetColors => '预设颜色';

  @override
  String get customColor => '自定义颜色';

  @override
  String get themeColorChanged => '主题色已更改';

  // 主题色名称
  @override
  String get themeColorRed => '红色';

  @override
  String get themeColorOrange => '橙色';

  @override
  String get themeColorYellow => '黄色';

  @override
  String get themeColorGreen => '绿色';

  @override
  String get themeColorBlue => '蓝色';

  @override
  String get themeColorIndigo => '靛蓝';

  @override
  String get themeColorPurple => '紫色';

  @override
  String get themeColorDeepPurple => '深紫';

  @override
  String get themeColorTeal => '青色';

  @override
  String get themeColorCyan => '青蓝';

  // ==================== 字体设置 ====================
  @override
  String get fontSettingsTitle => '字体设置';

  @override
  String get fontScale => '字体缩放';

  @override
  String get fontScaleDesc => '调整应用中所有文字的大小';

  @override
  String get previewText => '预览文字';

  @override
  String get previewTextContent => '这是一段预览文字，用于展示字体大小效果。';

  @override
  String get fontScaleChanged => '字体缩放已更改';

  // ==================== 语言设置 ====================
  @override
  String get languageSettingsTitle => '语言设置';

  @override
  String get languageFollowSystem => '跟随系统';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChanged => '语言已切换';

  // ==================== 版本信息 ====================
  @override
  String get versionInfoTitle => '版本信息';

  @override
  String get currentVersion => '当前版本';

  @override
  String get buildNumber => '构建号';

  @override
  String get flutterVersion => 'Flutter 版本';

  @override
  String get dartVersion => 'Dart 版本';

  @override
  String get platform => '平台';

  // ==================== 日志查看器 ====================
  @override
  String get logViewerTitle => '日志查看器';

  @override
  String get logViewerDesc => '查看应用运行日志';

  @override
  String get devModeOnly => '仅开发模式可用';

  // ==================== 设置项副标题 ====================
  @override
  String get darkModeSubtitle => '跟随系统';

  @override
  String get themeColorSubtitle => '当前主题色';

  @override
  String get fontSettingsSubtitle => '字体缩放 100%';

  @override
  String get languageSettingsSubtitle => '简体中文';

  @override
  String get versionInfoSubtitle => 'v1.0.0';

  @override
  String get logViewerSubtitle => '开发模式 - 查看应用日志';

  // ==================== 提示信息 ====================
  @override
  String get featureInDevelopment => '功能开发中';

  @override
  String get comingSoon => '敬请期待';
}
