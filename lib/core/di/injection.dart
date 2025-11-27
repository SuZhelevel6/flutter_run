import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../settings/settings_cubit.dart';
import '../../features/blog/data/datasources/blog_remote_datasource.dart';
import '../../features/blog/data/repositories/blog_repository_impl.dart';
import '../../features/blog/domain/repositories/blog_repository.dart';
import '../../features/blog/presentation/bloc/blog_bloc.dart';

/// 全局依赖注入容器实例
///
/// 使用方式:
/// ```dart
/// // 获取单例
/// final apiClient = getIt<ApiClient>();
///
/// // 获取工厂实例(每次调用创建新实例)
/// final blogBloc = getIt<BlogBloc>();
/// ```
final GetIt getIt = GetIt.instance;

/// 初始化依赖注入
///
/// 在应用启动时调用此方法初始化所有依赖
/// 必须在 runApp() 之前调用
///
/// 此方法内部会确保 WidgetsFlutterBinding 初始化,
/// 因为 SharedPreferences 需要 binding 才能工作
///
/// 示例:
/// ```dart
/// void main() async {
///   await setupDependencies();  // 内部会初始化 binding
///   runApp(const MyApp());
/// }
/// ```
Future<void> setupDependencies() async {
  // ==================== Flutter Binding ====================
  // 确保 Flutter binding 初始化 (SharedPreferences 需要)
  WidgetsFlutterBinding.ensureInitialized();

  // ==================== 外部依赖 ====================
  // SharedPreferences (异步初始化,需要 await)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // ==================== 核心服务 ====================
  // ApiClient - 网络请求客户端 (单例)
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // ==================== Blog 模块 ====================
  _setupBlogModule();

  // ==================== Settings 模块 ====================
  _setupSettingsModule();
}

/// 配置 Blog 模块依赖
void _setupBlogModule() {
  // DataSource - 数据源 (单例)
  getIt.registerLazySingleton<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repository - 仓储 (单例)
  getIt.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(getIt<BlogRemoteDataSource>()),
  );

  // Bloc - 业务逻辑组件 (工厂,每次创建新实例)
  // 使用 Factory 是因为每个页面需要独立的 Bloc 实例
  getIt.registerFactory<BlogBloc>(
    () => BlogBloc(getIt<BlogRepository>()),
  );
}

/// 配置 Settings 模块依赖
void _setupSettingsModule() {
  // SettingsCubit - 设置状态管理 (单例)
  // 使用单例是因为设置是全局共享的
  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(),
  );
}

/// 重置依赖注入容器
///
/// 主要用于测试场景,重置所有已注册的依赖
Future<void> resetDependencies() async {
  await getIt.reset();
}
