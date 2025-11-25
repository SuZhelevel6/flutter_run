import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'os.dart';

/// 应用环境信息
///
/// 提供全局的平台检测能力
/// 参考 FlutterUnit: fx_env/lib/src/app_env/app_env.dart
class AppEnv {
  late final OS _os;
  late final OSChecker _checker;

  AppEnv() {
    _os = _initOS();
    _checker = OSChecker(_os);
  }

  /// 初始化操作系统类型
  ///
  /// 检测顺序:
  /// 1. Web 优先 (kIsWeb)
  /// 2. 桌面平台 (Windows, macOS, Linux)
  /// 3. 移动平台 (iOS, Android)
  OS _initOS() {
    // Web 平台优先判断
    if (kIsWeb) return OS.web;

    // 桌面平台
    if (Platform.isWindows) return OS.windows;
    if (Platform.isMacOS) return OS.macos;
    if (Platform.isLinux) return OS.linux;

    // 移动平台
    if (Platform.isIOS) return OS.ios;
    if (Platform.isAndroid) return OS.android;

    return OS.unknown;
  }

  /// 当前操作系统
  OS get os => _os;

  /// 是否为 Web 平台
  bool get isWeb => _checker.isWeb;

  /// 是否为 Android 平台
  bool get isAndroid => _checker.isAndroid;

  /// 是否为 iOS 平台
  bool get isIos => _checker.isIos;

  /// 是否为 Windows 平台
  bool get isWindows => _checker.isWindows;

  /// 是否为 macOS 平台
  bool get isMacOS => _checker.isMacOS;

  /// 是否为 Linux 平台
  bool get isLinux => _checker.isLinux;

  /// 是否为桌面平台 (Windows, macOS, Linux)
  bool get isDesktop => _checker.isDesktop;

  /// 是否为移动平台 (iOS, Android)
  bool get isMobile => _checker.isMobile;

  /// 核心方法: 是否使用桌面端 UI
  ///
  /// 判断公式: isDesktopUI = isWeb || isDesktop
  /// - Web 被视为桌面端 UI (通常在大屏幕上使用)
  /// - Desktop 包括: macOS, Windows, Linux
  ///
  /// 使用场景:
  /// - 根据此属性决定加载桌面端还是移动端 UI
  /// - 桌面端: ShellRoute + 左侧导航 + Row 分栏布局
  /// - 移动端: 独立路由 + 底部导航 + PageView 滑动
  bool get isDesktopUI => _checker.isDesktopUI;

  @override
  String toString() => _checker.toString();
}
