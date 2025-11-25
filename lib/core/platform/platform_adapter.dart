import 'app_env.dart';

/// 全局应用环境实例
///
/// 初始化时机: Dart VM 加载全局变量时 (在 main() 之前自动执行)
/// 参考 FlutterUnit: fx_env/lib/src/global.dart
final AppEnv kAppEnv = AppEnv();

/// 平台适配器
///
/// 提供平台相关的便捷方法
/// 参考 FlutterUnit: fx_platform_adapter
class PlatformAdapter {
  /// 私有构造函数，防止实例化
  PlatformAdapter._();

  /// 是否为桌面端 UI
  static bool get isDesktopUI => kAppEnv.isDesktopUI;

  /// 是否为移动端 UI
  static bool get isMobileUI => kAppEnv.isMobile;

  /// 是否为 Web 平台
  static bool get isWeb => kAppEnv.isWeb;

  /// 是否为桌面平台 (不包括 Web)
  static bool get isDesktop => kAppEnv.isDesktop;

  /// 是否为移动平台
  static bool get isMobile => kAppEnv.isMobile;

  /// 是否为 Android
  static bool get isAndroid => kAppEnv.isAndroid;

  /// 是否为 iOS
  static bool get isIos => kAppEnv.isIos;

  /// 是否为 macOS
  static bool get isMacOS => kAppEnv.isMacOS;

  /// 是否为 Windows
  static bool get isWindows => kAppEnv.isWindows;

  /// 是否为 Linux
  static bool get isLinux => kAppEnv.isLinux;

  /// 获取平台名称
  static String get platformName => kAppEnv.os.name;

  /// 打印平台信息
  static void printPlatformInfo() {
    // ignore: avoid_print
    print('=== Platform Info ===');
    // ignore: avoid_print
    print('Platform: $platformName');
    // ignore: avoid_print
    print('Is Desktop UI: $isDesktopUI');
    // ignore: avoid_print
    print('Is Mobile UI: $isMobileUI');
    // ignore: avoid_print
    print('Is Web: $isWeb');
    // ignore: avoid_print
    print('Is Desktop: $isDesktop');
    // ignore: avoid_print
    print('Is Mobile: $isMobile');
    // ignore: avoid_print
    print('====================');
  }
}
