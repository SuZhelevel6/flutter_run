import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

/// ArticleModel: 文章数据模型
///
/// 对应 WanAndroid API 的文章数据结构
///
/// API: GET /article/list/{page}/json
/// 返回格式:
/// {
///   "data": {
///     "curPage": 1,
///     "datas": [
///       {
///         "id": 1,
///         "title": "标题",
///         "author": "作者",
///         "link": "链接",
///         "desc": "描述",
///         "envelopePic": "封面图",
///         "publishTime": 1234567890,
///         "chapterName": "分类",
///         "superChapterName": "父分类",
///         "collect": false
///       }
///     ],
///     "pageCount": 100
///   },
///   "errorCode": 0,
///   "errorMsg": ""
/// }
@JsonSerializable()
class ArticleModel {
  /// 文章 ID
  final int id;

  /// 标题
  final String title;

  /// 作者
  final String author;

  /// 链接
  final String link;

  /// 描述
  final String desc;

  /// 封面图
  final String envelopePic;

  /// 发布时间 (时间戳,毫秒)
  final int publishTime;

  /// 分类名称
  final String chapterName;

  /// 父分类名称
  final String superChapterName;

  /// 是否收藏
  final bool collect;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.author,
    required this.link,
    required this.desc,
    required this.envelopePic,
    required this.publishTime,
    required this.chapterName,
    required this.superChapterName,
    required this.collect,
  });

  /// 从 JSON 反序列化
  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  /// 序列化为 JSON
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  /// 是否有封面图
  bool get hasCover => envelopePic.isNotEmpty;

  /// 格式化发布时间
  DateTime get publishDateTime =>
      DateTime.fromMillisecondsSinceEpoch(publishTime);

  @override
  String toString() {
    return 'ArticleModel(id: $id, title: $title, author: $author)';
  }
}

/// ArticleListResponse: 文章列表响应
///
/// 包装分页数据
@JsonSerializable()
class ArticleListResponse {
  /// 当前页码
  final int curPage;

  /// 文章列表
  final List<ArticleModel> datas;

  /// 总页数
  final int pageCount;

  const ArticleListResponse({
    required this.curPage,
    required this.datas,
    required this.pageCount,
  });

  /// 从 JSON 反序列化
  factory ArticleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleListResponseFromJson(json);

  /// 序列化为 JSON
  Map<String, dynamic> toJson() => _$ArticleListResponseToJson(this);

  /// 是否还有更多数据
  bool get hasMore => curPage < pageCount;

  @override
  String toString() {
    return 'ArticleListResponse(curPage: $curPage, count: ${datas.length}, pageCount: $pageCount)';
  }
}
