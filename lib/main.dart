import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/logging/talker_config.dart';
import 'core/logging/app_bloc_observer.dart';
import 'core/platform/platform_adapter.dart';

void main() {
  // 1. 初始化日志系统（必须最早）
  TalkerConfig.init();

  // 2. 配置 BLoC 观察器
  Bloc.observer = AppBlocObserver();

  // 3. 打印平台信息（开发环境）
  PlatformAdapter.printPlatformInfo();

  // 4. 启动应用
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Run',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Run - Clean Architecture'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Clean Architecture 项目已初始化',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '平台: ${PlatformAdapter.platformName}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'UI类型: ${PlatformAdapter.isDesktopUI ? "桌面端" : "移动端"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
