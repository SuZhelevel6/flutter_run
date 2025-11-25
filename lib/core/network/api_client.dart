import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../error/exceptions.dart';
import '../logging/talker_config.dart';

/// ApiClient: 网络请求客户端
///
/// 基于 Dio 封装,提供:
/// - 统一的请求配置
/// - 统一的错误处理
/// - 请求/响应拦截
/// - 调试支持
///
/// 使用示例:
/// ```dart
/// final apiClient = ApiClient();
///
/// // GET 请求
/// final response = await apiClient.get('/banner/json');
///
/// // POST 请求
/// final response = await apiClient.post('/login', data: {
///   'username': 'test',
///   'password': '123456',
/// });
/// ```
class ApiClient {
  late final Dio _dio;

  /// Base URL
  static const String _baseUrl = 'https://www.wanandroid.com/';

  /// 连接超时时间
  static const Duration _connectTimeout = Duration(seconds: 30);

  /// 接收超时时间
  static const Duration _receiveTimeout = Duration(seconds: 30);

  /// 构造函数
  ///
  /// [enableDebugProxy]: 是否启用调试代理 (仅在 Debug 模式下有效)
  /// [proxyIp]: 代理 IP 地址
  /// [proxyPort]: 代理端口号
  ApiClient({
    bool enableDebugProxy = false,
    String proxyIp = '192.168.102.125',
    int proxyPort = 8888,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          HttpHeaders.userAgentHeader:
              'FlutterRun/1.0.0 (Android;12;1080*2400;Scale=3.0)',
          HttpHeaders.acceptHeader: 'application/json',
        },
      ),
    );

    // 添加拦截器
    _setupInterceptors();

    // Debug 模式下启用代理 (用于抓包调试)
    if (kDebugMode && enableDebugProxy) {
      _enableProxy(proxyIp, proxyPort);
    }
  }

  /// 设置拦截器
  void _setupInterceptors() {
    // 使用 Talker Dio Logger 替代原有的简单日志拦截器
    _dio.interceptors.add(
      TalkerDioLogger(
        talker: TalkerConfig.talker,
        settings: TalkerDioLoggerSettings(
          // 是否打印请求头
          printRequestHeaders: kDebugMode,
          // 是否打印响应头
          printResponseHeaders: kDebugMode,
          // 是否打印响应数据
          printResponseData: kDebugMode,
          // 是否打印请求数据
          printRequestData: kDebugMode,
          // 是否打印错误数据
          printErrorData: true,
          // 是否打印响应消息
          printResponseMessage: kDebugMode,
        ),
      ),
    );

    // 添加错误处理拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // 转换为自定义异常
          final exception = _handleDioError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: exception,
              type: error.type,
            ),
          );
        },
      ),
    );
  }

  /// 启用调试代理 (用于抓包)
  void _enableProxy(String ip, int port) {
    final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;

    adapter.createHttpClient = () {
      final client = HttpClient();
      client.findProxy = (uri) => 'PROXY $ip:$port';
      client.badCertificateCallback = (cert, host, port) => true; // 信任所有证书

      return client;
    };

    debugPrint('🔧 调试代理已启用: $ip:$port');
  }

  /// 处理 Dio 错误,转换为自定义异常
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkException('连接超时,请检查网络');

      case DioExceptionType.sendTimeout:
        return const NetworkException('发送超时,请检查网络');

      case DioExceptionType.receiveTimeout:
        return const NetworkException('接收超时,请稍后重试');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return ServerException(
              '服务器错误 ($statusCode)',
              statusCode: statusCode,
            );
          } else if (statusCode >= 400) {
            return ServerException(
              '请求错误 ($statusCode)',
              statusCode: statusCode,
            );
          }
        }
        return ServerException('请求失败', statusCode: statusCode);

      case DioExceptionType.cancel:
        return const NetworkException('请求已取消');

      case DioExceptionType.connectionError:
        return const NetworkException('网络连接失败,请检查网络');

      case DioExceptionType.badCertificate:
        return const NetworkException('证书验证失败');

      case DioExceptionType.unknown:
        return NetworkException(error.message ?? '未知网络错误');
    }
  }

  /// GET 请求
  ///
  /// [path]: 请求路径 (相对于 baseUrl)
  /// [queryParameters]: 查询参数
  /// [options]: 请求选项
  ///
  /// 示例:
  /// ```dart
  /// final response = await apiClient.get(
  ///   '/article/list/0/json',
  ///   queryParameters: {'page': 0},
  /// );
  /// ```
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      // DioException 已经在拦截器中处理并附加了自定义异常
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleDioError(e);
    }
  }

  /// POST 请求
  ///
  /// [path]: 请求路径
  /// [data]: 请求体数据
  /// [queryParameters]: 查询参数
  /// [options]: 请求选项
  ///
  /// 示例:
  /// ```dart
  /// final response = await apiClient.post(
  ///   '/user/login',
  ///   data: {
  ///     'username': 'test',
  ///     'password': '123456',
  ///   },
  /// );
  /// ```
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleDioError(e);
    }
  }

  /// PUT 请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleDioError(e);
    }
  }

  /// DELETE 请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleDioError(e);
    }
  }

  /// 下载文件
  Future<Response> download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Object? data,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleDioError(e);
    }
  }

  /// 获取 Dio 实例 (用于高级用法)
  Dio get dio => _dio;
}
