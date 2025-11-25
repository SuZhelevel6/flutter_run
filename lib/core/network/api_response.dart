import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// ApiResponse: 统一的 API 响应封装
///
/// 对应后端返回的标准格式:
/// ```json
/// {
///   "data": T,              // 实际数据
///   "errorCode": 0,         // 错误码 (0 表示成功)
///   "errorMsg": ""          // 错误消息
/// }
/// ```
///
/// 使用示例:
/// ```dart
/// // 在 DataSource 中使用
/// Future<ApiResponse<List<BannerModel>>> fetchBanners() async {
///   final response = await dio.get<Map<String, dynamic>>('/banner/json');
///
///   return ApiResponse.fromJson(
///     response.data!,
///     (json) => (json as List<dynamic>)
///         .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
///         .toList(),
///   );
/// }
/// ```
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  /// 实际数据
  final T data;

  /// 错误码
  ///
  /// 0: 成功
  /// 非 0: 失败 (具体错误码由后端定义)
  final int errorCode;

  /// 错误消息
  ///
  /// 成功时为空字符串
  /// 失败时包含具体错误信息
  final String errorMsg;

  const ApiResponse({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
  });

  /// 从 JSON 反序列化
  ///
  /// [json]: JSON 对象
  /// [fromJsonT]: 泛型 T 的反序列化函数
  ///
  /// 示例:
  /// ```dart
  /// // 单个对象
  /// ApiResponse.fromJson(
  ///   json,
  ///   (data) => UserModel.fromJson(data as Map<String, dynamic>),
  /// )
  ///
  /// // 列表
  /// ApiResponse.fromJson(
  ///   json,
  ///   (data) => (data as List<dynamic>)
  ///       .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
  ///       .toList(),
  /// )
  /// ```
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  /// 序列化为 JSON
  ///
  /// [toJsonT]: 泛型 T 的序列化函数
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// 判断请求是否成功
  bool get isSuccess => errorCode == 0;

  /// 判断请求是否失败
  bool get isFailure => errorCode != 0;

  @override
  String toString() {
    return 'ApiResponse(data: $data, errorCode: $errorCode, errorMsg: $errorMsg)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiResponse<T> &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          errorCode == other.errorCode &&
          errorMsg == other.errorMsg;

  @override
  int get hashCode => Object.hash(data, errorCode, errorMsg);
}
