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
  String get navWorkspace => '会议工作台';

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

  // ==================== Widget 集录 ====================
  @override
  String get widgetShowcase => 'Widget 集录';

  @override
  String get widgetCategoryStateless => '无态组件';

  @override
  String get widgetCategoryStateful => '有态组件';

  @override
  String get widgetCategoryOther => '其他组件';

  @override
  String get widgetPreview => '预览效果';

  @override
  String get widgetSampleCode => '示例代码';

  @override
  String get copyCode => '复制代码';

  @override
  String get codeCopied => '代码已复制';

  @override
  String get noWidgets => '暂无组件';

  // ==================== Painter 模块 ====================
  @override
  String get painterTitle => '画板';

  @override
  String get painterUndo => '撤销';

  @override
  String get painterRedo => '重做';

  @override
  String get painterClear => '清空';

  @override
  String get painterClearCanvasTitle => '清空画布';

  @override
  String get painterClearCanvasMessage => '确定要清空所有内容吗？此操作可以撤销。';

  @override
  String get painterToolPen => '画笔';

  @override
  String get painterToolEraser => '橡皮擦';

  @override
  String get painterToolLine => '直线';

  @override
  String get painterToolArrow => '箭头';

  @override
  String get painterToolRectangle => '矩形';

  @override
  String get painterToolCircle => '圆形';

  @override
  String get painterSelectColor => '选择颜色';

  @override
  String get painterStrokeWidth => '线条粗细';

  @override
  String painterStrokeWidthValue(int value) => '线条粗细: ${value}px';

  // ==================== Workspace 模块 ====================
  @override
  String get workspaceLoading => '正在加载会议...';

  @override
  String get workspaceLoadFailed => '加载失败';

  @override
  String get workspaceCheckNetwork => '请检查网络连接后重试';

  @override
  String get workspaceRetry => '重试';

  @override
  String get workspaceGreetingLateNight => '夜深了';

  @override
  String get workspaceGreetingMorning => '早上好';

  @override
  String get workspaceGreetingForenoon => '上午好';

  @override
  String get workspaceGreetingNoon => '中午好';

  @override
  String get workspaceGreetingAfternoon => '下午好';

  @override
  String get workspaceGreetingEvening => '晚上好';

  @override
  String get workspaceRoomName => '3号会议室';

  @override
  String workspaceMeetingCount(int count) => '今天有 $count 场会议';

  @override
  String get workspaceNoMeetingToday => '今天暂无会议安排';

  @override
  String get workspaceQuickActions => '快捷入口';

  @override
  String get workspaceMeetingSchedule => '会议日程';

  @override
  String get workspaceNoMeetings => '暂无会议安排';

  @override
  String get workspaceEnjoyYourDay => '享受轻松的一天吧！';

  @override
  String get workspaceTodayMeetings => '今日会议';

  @override
  String get workspaceTomorrowMeetings => '明日会议';

  @override
  String workspaceMeetingCountUnit(int count) => '$count 场';

  @override
  String workspaceMeetingDuration(int minutes) => '$minutes分钟';

  @override
  String get workspaceMeetingStatusOngoing => '进行中';

  @override
  String get workspaceMeetingStatusUpcoming => '即将开始';

  @override
  String get workspaceMeetingStatusEnded => '已结束';

  @override
  String workspaceViewMeeting(String title) => '查看会议：$title';

  @override
  String get workspaceNoAttendees => '暂无参会人';

  @override
  String workspaceAttendeesAndMore(String names, int count) => '$names 等${count}人';

  @override
  String get workspaceActionWhiteboard => '白板';

  @override
  String get workspaceActionScreencast => '投屏';

  @override
  String get workspaceActionDocuments => '文档';

  @override
  String get workspaceActionSettings => '设置';

  @override
  String get workspaceActionMore => '更多';

  @override
  String workspaceFeatureNotAvailable(String feature) => '$feature功能暂未开放';

  // ==================== 通用 ====================
  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确定';

  @override
  String get commonWeekdayMon => '周一';

  @override
  String get commonWeekdayTue => '周二';

  @override
  String get commonWeekdayWed => '周三';

  @override
  String get commonWeekdayThu => '周四';

  @override
  String get commonWeekdayFri => '周五';

  @override
  String get commonWeekdaySat => '周六';

  @override
  String get commonWeekdaySun => '周日';

  @override
  String formatMonthDay(int month, int day) => '$month月$day日';

  @override
  String formatMonthDayWeekday(int month, int day, String weekday) => '$month月$day日 $weekday';
}
