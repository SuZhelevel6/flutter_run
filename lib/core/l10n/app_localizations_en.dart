import 'app_localizations.dart';

/// English localization
class AppLocalizationsEn extends AppLocalizations {
  const AppLocalizationsEn();

  @override
  String get languageCode => 'en';

  // ==================== Navigation ====================
  @override
  String get navWidget => 'Widgets';

  @override
  String get navBlog => 'Blog';

  @override
  String get navPainter => 'Painter';

  @override
  String get navWorkspace => 'Workspace';

  @override
  String get navTools => 'Tools';

  @override
  String get navAccount => 'Account';

  // ==================== Settings Page ====================
  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get fontSettings => 'Font Settings';

  @override
  String get languageSettings => 'Language';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get logViewer => 'Log Viewer';

  // ==================== Theme Mode ====================
  @override
  String get themeModeTitle => 'Dark Mode';

  @override
  String get followSystem => 'Follow System';

  @override
  String get followSystemDesc => 'Automatically switch theme based on system settings';

  @override
  String get manualSettings => 'Manual Settings';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkModeOption => 'Dark Mode';

  @override
  String get themeModeChanged => 'Theme mode changed';

  @override
  String get followSystemEnabled => 'Follow system enabled';

  @override
  String get followSystemDisabled => 'Follow system disabled';

  @override
  String get lightModeEnabled => 'Switched to light mode';

  @override
  String get darkModeEnabled => 'Switched to dark mode';

  // ==================== Theme Color ====================
  @override
  String get themeColorTitle => 'Theme Color';

  @override
  String get currentThemeColor => 'Current Theme Color';

  @override
  String get presetColors => 'Preset Colors';

  @override
  String get customColor => 'Custom Color';

  @override
  String get themeColorChanged => 'Theme color changed';

  // Theme Color Names
  @override
  String get themeColorRed => 'Red';

  @override
  String get themeColorOrange => 'Orange';

  @override
  String get themeColorYellow => 'Yellow';

  @override
  String get themeColorGreen => 'Green';

  @override
  String get themeColorBlue => 'Blue';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorPurple => 'Purple';

  @override
  String get themeColorDeepPurple => 'Deep Purple';

  @override
  String get themeColorTeal => 'Teal';

  @override
  String get themeColorCyan => 'Cyan';

  // ==================== Font Settings ====================
  @override
  String get fontSettingsTitle => 'Font Settings';

  @override
  String get fontScale => 'Font Scale';

  @override
  String get fontScaleDesc => 'Adjust the size of all text in the app';

  @override
  String get previewText => 'Preview Text';

  @override
  String get previewTextContent => 'This is a preview text to demonstrate the font size effect.';

  @override
  String get fontScaleChanged => 'Font scale changed';

  // ==================== Language Settings ====================
  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get languageFollowSystem => 'Follow System';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChanged => 'Language changed';

  // ==================== Version Info ====================
  @override
  String get versionInfoTitle => 'Version Info';

  @override
  String get currentVersion => 'Current Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get flutterVersion => 'Flutter Version';

  @override
  String get dartVersion => 'Dart Version';

  @override
  String get platform => 'Platform';

  // ==================== Log Viewer ====================
  @override
  String get logViewerTitle => 'Log Viewer';

  @override
  String get logViewerDesc => 'View application logs';

  @override
  String get devModeOnly => 'Development mode only';

  // ==================== Setting Item Subtitles ====================
  @override
  String get darkModeSubtitle => 'Follow System';

  @override
  String get themeColorSubtitle => 'Current Theme Color';

  @override
  String get fontSettingsSubtitle => 'Font Scale 100%';

  @override
  String get languageSettingsSubtitle => 'English';

  @override
  String get versionInfoSubtitle => 'v1.0.0';

  @override
  String get logViewerSubtitle => 'Dev Mode - View App Logs';

  // ==================== Hints ====================
  @override
  String get featureInDevelopment => 'Feature in development';

  @override
  String get comingSoon => 'Coming soon';

  // ==================== Widget Showcase ====================
  @override
  String get widgetShowcase => 'Widget Showcase';

  @override
  String get widgetCategoryStateless => 'Stateless';

  @override
  String get widgetCategoryStateful => 'Stateful';

  @override
  String get widgetCategoryOther => 'Other';

  @override
  String get widgetPreview => 'Preview';

  @override
  String get widgetSampleCode => 'Sample Code';

  @override
  String get copyCode => 'Copy Code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get noWidgets => 'No widgets available';

  // ==================== Painter Module ====================
  @override
  String get painterTitle => 'Whiteboard';

  @override
  String get painterUndo => 'Undo';

  @override
  String get painterRedo => 'Redo';

  @override
  String get painterClear => 'Clear';

  @override
  String get painterClearCanvasTitle => 'Clear Canvas';

  @override
  String get painterClearCanvasMessage => 'Are you sure you want to clear all content? This action can be undone.';

  @override
  String get painterToolPen => 'Pen';

  @override
  String get painterToolEraser => 'Eraser';

  @override
  String get painterToolLine => 'Line';

  @override
  String get painterToolArrow => 'Arrow';

  @override
  String get painterToolRectangle => 'Rectangle';

  @override
  String get painterToolCircle => 'Circle';

  @override
  String get painterSelectColor => 'Select Color';

  @override
  String get painterStrokeWidth => 'Stroke Width';

  @override
  String painterStrokeWidthValue(int value) => 'Stroke Width: ${value}px';

  // ==================== Workspace Module ====================
  @override
  String get workspaceLoading => 'Loading meetings...';

  @override
  String get workspaceLoadFailed => 'Load Failed';

  @override
  String get workspaceCheckNetwork => 'Please check your network and try again';

  @override
  String get workspaceRetry => 'Retry';

  @override
  String get workspaceGreetingLateNight => 'Late night';

  @override
  String get workspaceGreetingMorning => 'Good morning';

  @override
  String get workspaceGreetingForenoon => 'Good forenoon';

  @override
  String get workspaceGreetingNoon => 'Good noon';

  @override
  String get workspaceGreetingAfternoon => 'Good afternoon';

  @override
  String get workspaceGreetingEvening => 'Good evening';

  @override
  String get workspaceRoomName => 'Meeting Room 3';

  @override
  String workspaceMeetingCount(int count) => 'You have $count meetings today';

  @override
  String get workspaceNoMeetingToday => 'No meetings scheduled today';

  @override
  String get workspaceQuickActions => 'Quick Actions';

  @override
  String get workspaceMeetingSchedule => 'Meeting Schedule';

  @override
  String get workspaceNoMeetings => 'No meetings scheduled';

  @override
  String get workspaceEnjoyYourDay => 'Enjoy your day!';

  @override
  String get workspaceTodayMeetings => 'Today';

  @override
  String get workspaceTomorrowMeetings => 'Tomorrow';

  @override
  String workspaceMeetingCountUnit(int count) => '$count meetings';

  @override
  String workspaceMeetingDuration(int minutes) => '${minutes}min';

  @override
  String get workspaceMeetingStatusOngoing => 'Ongoing';

  @override
  String get workspaceMeetingStatusUpcoming => 'Upcoming';

  @override
  String get workspaceMeetingStatusEnded => 'Ended';

  @override
  String workspaceViewMeeting(String title) => 'View meeting: $title';

  @override
  String get workspaceNoAttendees => 'No attendees';

  @override
  String workspaceAttendeesAndMore(String names, int count) => '$names and $count others';

  @override
  String get workspaceActionWhiteboard => 'Whiteboard';

  @override
  String get workspaceActionScreencast => 'Screen Cast';

  @override
  String get workspaceActionDocuments => 'Documents';

  @override
  String get workspaceActionSettings => 'Settings';

  @override
  String get workspaceActionMore => 'More';

  @override
  String workspaceFeatureNotAvailable(String feature) => '$feature is not available yet';

  // ==================== Common ====================
  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonWeekdayMon => 'Mon';

  @override
  String get commonWeekdayTue => 'Tue';

  @override
  String get commonWeekdayWed => 'Wed';

  @override
  String get commonWeekdayThu => 'Thu';

  @override
  String get commonWeekdayFri => 'Fri';

  @override
  String get commonWeekdaySat => 'Sat';

  @override
  String get commonWeekdaySun => 'Sun';

  @override
  String formatMonthDay(int month, int day) => 'M$month D$day';

  @override
  String formatMonthDayWeekday(int month, int day, String weekday) => 'M$month D$day $weekday';
}
