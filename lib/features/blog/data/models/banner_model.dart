import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

/// BannerModel: 轮播图数据模型
///
/// 对应 WanAndroid API 的 Banner 数据结构
///
/// API: GET /banner/json
/// 返回格式:
/// {
///   "data": [
///     {
///       "id": 1,
///       "title": "标题",
///       "imagePath": "图片URL",
///       "url": "跳转链接",
///       "desc": "描述",
///       "isVisible": 1,
///       "order": 0,
///       "type": 0
///     }
///   ],
///   "errorCode": 0,
///   "errorMsg": ""
/// }
@JsonSerializable()
class BannerModel {
  /// Banner ID
  final int id;

  /// 标题
  final String title;

  /// 图片 URL
  final String imagePath;

  /// 跳转链接
  final String url;

  /// 描述
  final String desc;

  /// 是否可见 (1: 可见, 0: 不可见)
  final int isVisible;

  /// 排序
  final int order;

  /// 类型
  final int type;

  const BannerModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.url,
    required this.desc,
    required this.isVisible,
    required this.order,
    required this.type,
  });

  /// 从 JSON 反序列化
  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  /// 序列化为 JSON
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

  @override
  String toString() {
    return 'BannerModel(id: $id, title: $title, imagePath: $imagePath)';
  }
}
