import 'package:flutter/material.dart';
import 'app_localizations_zh.dart';
import 'app_localizations_en.dart';

/// 应用国际化基类
///
/// 定义所有需要国际化的文本
/// 参考 FlutterPlay 的国际化实现方式
abstract class AppLocalizations {
  const AppLocalizations();

  /// 从上下文获取当前语言的国际化实例
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// 语言代码
  String get languageCode;

  // ==================== 通用 ====================
  String get appName => 'Flutter Run';

  // ==================== 导航栏 ====================
  String get navWidget;
  String get navBlog;
  String get navPainter;
  String get navWorkspace;
  String get navTools;
  String get navAccount;

  // ==================== 设置页面 ====================
  String get settings;
  String get darkMode;
  String get themeColor;
  String get fontSettings;
  String get languageSettings;
  String get versionInfo;
  String get logViewer;

  // ==================== 主题模式 ====================
  String get themeModeTitle;
  String get followSystem;
  String get followSystemDesc;
  String get manualSettings;
  String get lightMode;
  String get darkModeOption;
  String get themeModeChanged;
  String get followSystemEnabled;
  String get followSystemDisabled;
  String get lightModeEnabled;
  String get darkModeEnabled;

  // ==================== 主题色 ====================
  String get themeColorTitle;
  String get currentThemeColor;
  String get presetColors;
  String get customColor;
  String get themeColorChanged;

  // 主题色名称
  String get themeColorRed;
  String get themeColorOrange;
  String get themeColorYellow;
  String get themeColorGreen;
  String get themeColorBlue;
  String get themeColorIndigo;
  String get themeColorPurple;
  String get themeColorDeepPurple;
  String get themeColorTeal;
  String get themeColorCyan;

  // ==================== 字体设置 ====================
  String get fontSettingsTitle;
  String get fontScale;
  String get fontScaleDesc;
  String get previewText;
  String get previewTextContent;
  String get fontScaleChanged;

  // ==================== 语言设置 ====================
  String get languageSettingsTitle;
  String get languageFollowSystem;
  String get languageSimplifiedChinese;
  String get languageEnglish;
  String get languageChanged;

  // ==================== 版本信息 ====================
  String get versionInfoTitle;
  String get currentVersion;
  String get buildNumber;
  String get flutterVersion;
  String get dartVersion;
  String get platform;

  // ==================== 日志查看器 ====================
  String get logViewerTitle;
  String get logViewerDesc;
  String get devModeOnly;

  // ==================== 设置项副标题 ====================
  String get darkModeSubtitle;
  String get themeColorSubtitle;
  String get fontSettingsSubtitle;
  String get languageSettingsSubtitle;
  String get versionInfoSubtitle;
  String get logViewerSubtitle;

  // ==================== 提示信息 ====================
  String get featureInDevelopment;
  String get comingSoon;

  // ==================== Widget 集录 ====================
  String get widgetShowcase;
  String get widgetCategoryStateless;
  String get widgetCategoryStateful;
  String get widgetCategoryOther;
  String get widgetPreview;
  String get widgetSampleCode;
  String get copyCode;
  String get codeCopied;
  String get noWidgets;

  // ==================== Painter 模块 ====================
  String get painterTitle;
  String get painterUndo;
  String get painterRedo;
  String get painterClear;
  String get painterClearCanvasTitle;
  String get painterClearCanvasMessage;
  String get painterToolPen;
  String get painterToolEraser;
  String get painterToolLine;
  String get painterToolArrow;
  String get painterToolRectangle;
  String get painterToolCircle;
  String get painterSelectColor;
  String get painterStrokeWidth;
  String painterStrokeWidthValue(int value);

  // ==================== Workspace 模块 ====================
  String get workspaceLoading;
  String get workspaceLoadFailed;
  String get workspaceCheckNetwork;
  String get workspaceRetry;
  String get workspaceGreetingLateNight;
  String get workspaceGreetingMorning;
  String get workspaceGreetingForenoon;
  String get workspaceGreetingNoon;
  String get workspaceGreetingAfternoon;
  String get workspaceGreetingEvening;
  String get workspaceRoomName;
  String workspaceMeetingCount(int count);
  String get workspaceNoMeetingToday;
  String get workspaceQuickActions;
  String get workspaceMeetingSchedule;
  String get workspaceNoMeetings;
  String get workspaceEnjoyYourDay;
  String get workspaceTodayMeetings;
  String get workspaceTomorrowMeetings;
  String workspaceMeetingCountUnit(int count);
  String workspaceMeetingDuration(int minutes);
  String get workspaceMeetingStatusOngoing;
  String get workspaceMeetingStatusUpcoming;
  String get workspaceMeetingStatusEnded;
  String workspaceViewMeeting(String title);
  String get workspaceNoAttendees;
  String workspaceAttendeesAndMore(String names, int count);
  String get workspaceActionWhiteboard;
  String get workspaceActionScreencast;
  String get workspaceActionDocuments;
  String get workspaceActionSettings;
  String get workspaceActionMore;
  String workspaceFeatureNotAvailable(String feature);

  // ==================== 通用 ====================
  String get commonCancel;
  String get commonConfirm;
  String get commonWeekdayMon;
  String get commonWeekdayTue;
  String get commonWeekdayWed;
  String get commonWeekdayThu;
  String get commonWeekdayFri;
  String get commonWeekdaySat;
  String get commonWeekdaySun;
  String formatMonthDay(int month, int day);
  String formatMonthDayWeekday(int month, int day, String weekday);
}

/// 国际化委托
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // 根据语言代码返回对应的国际化实例
    switch (locale.languageCode) {
      case 'zh':
        return const AppLocalizationsZh();
      case 'en':
        return const AppLocalizationsEn();
      default:
        return const AppLocalizationsZh();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
