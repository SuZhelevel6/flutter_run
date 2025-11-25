/// 操作系统枚举
///
/// 定义所有支持的操作系统类型
enum OS {
  /// Web 平台
  web,

  /// Windows 平台
  windows,

  /// macOS 平台
  macos,

  /// Linux 平台
  linux,

  /// iOS 平台
  ios,

  /// Android 平台
  android,

  /// 未知平台
  unknown,
}

/// 操作系统检查器
///
/// 提供平台判断的便捷方法
/// 参考 FlutterUnit: fx_env/lib/src/app_env/os.dart
class OSChecker {
  final OS os;

  // 基础平台判断
  late final bool isWeb;
  late final bool isAndroid;
  late final bool isIos;
  late final bool isWindows;
  late final bool isMacOS;
  late final bool isLinux;

  // 组合判断
  late final bool isDesktop;
  late final bool isMobile;

  /// 核心属性: 是否使用桌面端 UI
  ///
  /// 判断公式: isDesktopUI = isWeb || isDesktop
  /// - Web 被视为桌面端 UI (通常在大屏幕上使用)
  /// - Desktop 包括: macOS, Windows, Linux
  late final bool isDesktopUI;

  OSChecker(this.os) {
    // 1. 基础平台判断
    isWeb = os == OS.web;
    isAndroid = !isWeb && os == OS.android;
    isIos = !isWeb && os == OS.ios;
    isWindows = !isWeb && os == OS.windows;
    isMacOS = !isWeb && os == OS.macos;
    isLinux = !isWeb && os == OS.linux;

    // 2. 组合判断
    isDesktop = !isWeb && (isMacOS || isWindows || isLinux);
    isMobile = !isWeb && (isAndroid || isIos);

    // 3. 核心逻辑: 桌面端 UI 判断
    isDesktopUI = isWeb || isDesktop;
  }

  @override
  String toString() {
    return 'OSChecker('
        'os: $os, '
        'isDesktopUI: $isDesktopUI, '
        'isDesktop: $isDesktop, '
        'isMobile: $isMobile, '
        'isWeb: $isWeb'
        ')';
  }
}
