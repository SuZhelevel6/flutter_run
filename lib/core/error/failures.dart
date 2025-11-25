import '../network/result.dart';

/// NetworkFailure: 网络错误
///
/// 使用场景:
/// - 网络连接失败
/// - 请求超时
/// - DNS 解析失败
/// - 无网络连接
///
/// 示例:
/// ```dart
/// return Failure(NetworkFailure('连接超时,请检查网络'));
/// ```
class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

/// ServerFailure: 服务器错误
///
/// 使用场景:
/// - HTTP 状态码 5xx (服务器内部错误)
/// - HTTP 状态码 4xx (客户端错误,如 404、403)
/// - 服务器无响应
///
/// 示例:
/// ```dart
/// return Failure(ServerFailure('服务器错误', statusCode: 500));
/// ```
class ServerFailure extends AppFailure {
  /// HTTP 状态码
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  String toString() =>
      'ServerFailure(message: $message, statusCode: $statusCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ServerFailure &&
          statusCode == other.statusCode;

  @override
  int get hashCode => Object.hash(message, statusCode);
}

/// CacheFailure: 缓存错误
///
/// 使用场景:
/// - 缓存读取失败
/// - 缓存写入失败
/// - 缓存数据损坏
/// - 缓存已过期
///
/// 示例:
/// ```dart
/// return Failure(CacheFailure('缓存读取失败'));
/// ```
class CacheFailure extends AppFailure {
  const CacheFailure(super.message);
}

/// ParseFailure: 数据解析错误
///
/// 使用场景:
/// - JSON 解析失败
/// - 数据格式不正确
/// - 必填字段缺失
/// - 数据类型不匹配
///
/// 示例:
/// ```dart
/// return Failure(ParseFailure('JSON 解析失败: ${e.toString()}'));
/// ```
class ParseFailure extends AppFailure {
  const ParseFailure(super.message);
}

/// BusinessFailure: 业务错误
///
/// 使用场景:
/// - 接口返回 errorCode != 0
/// - 业务规则验证失败
/// - 用户未登录
/// - 权限不足
/// - 余额不足
///
/// 示例:
/// ```dart
/// // API 返回: { "errorCode": 1001, "errorMsg": "用户未登录" }
/// return Failure(BusinessFailure('用户未登录', 1001));
/// ```
class BusinessFailure extends AppFailure {
  /// 业务错误码
  final int errorCode;

  const BusinessFailure(super.message, this.errorCode);

  @override
  String toString() =>
      'BusinessFailure(message: $message, errorCode: $errorCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is BusinessFailure &&
          errorCode == other.errorCode;

  @override
  int get hashCode => Object.hash(message, errorCode);
}

/// DatabaseFailure: 数据库错误
///
/// 使用场景:
/// - SQLite 查询失败
/// - 数据库连接失败
/// - 数据库写入失败
/// - 数据库版本迁移失败
///
/// 示例:
/// ```dart
/// return Failure(DatabaseFailure('数据库查询失败: ${e.toString()}'));
/// ```
class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message);
}

/// UnknownFailure: 未知错误
///
/// 使用场景:
/// - 无法归类的异常
/// - 意外的运行时错误
/// - 第三方库抛出的未知异常
///
/// 示例:
/// ```dart
/// catch (e) {
///   return Failure(UnknownFailure(e.toString()));
/// }
/// ```
class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message);
}

/// ValidationFailure: 验证错误
///
/// 使用场景:
/// - 表单验证失败
/// - 参数验证失败
/// - 数据格式验证失败
///
/// 示例:
/// ```dart
/// if (email.isEmpty) {
///   return Failure(ValidationFailure('邮箱不能为空'));
/// }
/// ```
class ValidationFailure extends AppFailure {
  /// 验证失败的字段名
  final String? fieldName;

  const ValidationFailure(super.message, {this.fieldName});

  @override
  String toString() =>
      'ValidationFailure(message: $message, fieldName: $fieldName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ValidationFailure &&
          fieldName == other.fieldName;

  @override
  int get hashCode => Object.hash(message, fieldName);
}
