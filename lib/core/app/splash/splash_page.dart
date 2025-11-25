import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fx_boot_starter/bloc/bloc.dart';
import 'package:fx_boot_starter/bloc/state.dart';
import '../app_config.dart';

/// FlutterRunSplash: 启动页
///
/// 显示应用启动时的加载界面，带有动画效果
/// 动画效果：app_splash.png 慢慢淡入显示
///
/// 延迟跳转策略：
/// - 动画时长：1.5 秒
/// - 最小显示时长：2.0 秒（确保用户能看到完整动画）
/// - 当启动完成且最小时长已到时，自动跳转到首页
class FlutterRunSplash extends StatefulWidget {
  const FlutterRunSplash({super.key});

  @override
  State<FlutterRunSplash> createState() => _FlutterRunSplashState();
}

class _FlutterRunSplashState extends State<FlutterRunSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // 记录启动开始时间
  late DateTime _startTime;
  // 最小显示时长（毫秒）
  static const int _minDisplayDuration = 2000;

  @override
  void initState() {
    super.initState();

    // 记录启动时间
    _startTime = DateTime.now();

    // 创建动画控制器 (持续时间 1.5 秒)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 淡入动画：从 0.0 到 1.0
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // 启动动画
    _controller.forward();

    // 监听启动状态，当启动完成时跳转
    _listenToStartupState();
  }

  /// 监听启动状态
  void _listenToStartupState() {
    // 使用 BlocListener 监听启动状态
    // 当状态变为 AppStartSuccess 时，延迟跳转
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AppStartBloc<AppConfig>>();
      bloc.stream.listen((state) {
        if (state is AppStartSuccess && mounted) {
          _navigateToHome();
        }
      });
    });
  }

  /// 跳转到首页
  Future<void> _navigateToHome() async {
    // 计算已经显示的时长
    final elapsedTime = DateTime.now().difference(_startTime).inMilliseconds;

    // 如果显示时长不足最小时长，则等待
    if (elapsedTime < _minDisplayDuration) {
      final remainingTime = _minDisplayDuration - elapsedTime;
      await Future.delayed(Duration(milliseconds: remainingTime));
    }

    // 跳转到首页
    if (mounted) {
      context.go('/widget');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // 设置状态栏样式
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 状态栏背景透明
        statusBarIconBrightness: Brightness.dark, // 状态栏图标深色
        systemNavigationBarColor: Colors.transparent, // 导航栏透明
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: _SplashBody(
            fadeAnimation: _fadeAnimation,
          ),
        ),
      ),
    );
  }
}

/// _SplashBody: 启动页主体内容
class _SplashBody extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const _SplashBody({
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/images/app_splash.png',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
