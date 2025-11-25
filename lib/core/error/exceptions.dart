/// AppException: 所有异常的基类
///
/// 异常 (Exception) 用于在 Data Layer 抛出
/// 然后在 Repository 中捕获并转换为 Failure
///
///
/// 使用场景:
/// - DataSource 层抛出异常
/// - Repository 层捕获异常并转换为 Result(Failure)
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// NetworkException: 网络异常
///
/// 使用场景:
/// - Dio 请求失败
/// - 连接超时
/// - 接收超时
/// - 无网络连接
///
/// 示例:
/// ```dart
/// // DataSource 层
/// Future<List<BannerModel>> fetchBanners() async {
///   try {
///     final response = await dio.get('/banners');
///     return parseBanners(response.data);
///   } on DioException catch (e) {
///     if (e.type == DioExceptionType.connectionTimeout) {
///       throw NetworkException('连接超时');
///     }
///     throw NetworkException(e.message ?? '网络错误');
///   }
/// }
///
/// // Repository 层
/// Future<Result<List<Banner>>> getBanners() async {
///   try {
///     final data = await remoteDataSource.fetchBanners();
///     return Success(data);
///   } on NetworkException catch (e) {
///     return Failure(NetworkFailure(e.message));
///   }
/// }
/// ```
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// ServerException: 服务器异常
///
/// 使用场景:
/// - HTTP 状态码 4xx/5xx
/// - 服务器返回错误响应
///
/// 示例:
/// ```dart
/// if (response.statusCode >= 400) {
///   throw ServerException(
///     '服务器错误',
///     statusCode: response.statusCode,
///   );
/// }
/// ```
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});

  @override
  String toString() => '$runtimeType: $message (statusCode: $statusCode)';
}

/// CacheException: 缓存异常
///
/// 使用场景:
/// - SharedPreferences 读写失败
/// - 缓存数据损坏
/// - 缓存空间不足
///
/// 示例:
/// ```dart
/// try {
///   await prefs.setString('key', value);
/// } catch (e) {
///   throw CacheException('缓存写入失败: ${e.toString()}');
/// }
/// ```
class CacheException extends AppException {
  const CacheException(super.message);
}

/// ParseException: 解析异常
///
/// 使用场景:
/// - JSON 解析失败
/// - 数据格式错误
/// - 类型转换失败
///
/// 示例:
/// ```dart
/// try {
///   return BannerModel.fromJson(json);
/// } catch (e) {
///   throw ParseException('数据解析失败: ${e.toString()}');
/// }
/// ```
class ParseException extends AppException {
  const ParseException(super.message);
}

/// DatabaseException: 数据库异常
///
/// 使用场景:
/// - SQLite 操作失败
/// - 数据库连接失败
/// - SQL 语句错误
///
/// 示例:
/// ```dart
/// try {
///   await db.insert('table', data);
/// } catch (e) {
///   throw DatabaseException('数据库插入失败: ${e.toString()}');
/// }
/// ```
class DatabaseException extends AppException {
  const DatabaseException(super.message);
}

/// ValidationException: 验证异常
///
/// 使用场景:
/// - 参数验证失败
/// - 数据格式验证失败
///
/// 示例:
/// ```dart
/// if (id <= 0) {
///   throw ValidationException('ID 必须大于 0');
/// }
/// ```
class ValidationException extends AppException {
  const ValidationException(super.message);
}
