import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/banner_model.dart';
import '../models/article_model.dart';

/// BlogRemoteDataSource: 博客远程数据源
///
/// 负责从网络获取博客相关数据:
/// - Banner 轮播图
/// - Article 文章列表
///
/// 数据源只负责数据获取,不处理业务逻辑
/// 异常会直接抛出,由 Repository 层统一处理
abstract class BlogRemoteDataSource {
  /// 获取轮播图列表
  ///
  /// API: GET /banner/json
  ///
  /// 返回:
  /// - Success: ApiResponse<List<BannerModel>>
  ///
  /// 异常:
  /// - NetworkException: 网络错误
  /// - ServerException: 服务器错误
  /// - ParseException: 解析错误
  Future<ApiResponse<List<BannerModel>>> fetchBanners();

  /// 获取文章列表
  ///
  /// API: GET /article/list/{page}/json
  ///
  /// 参数:
  /// - [page]: 页码 (从 0 开始)
  ///
  /// 返回:
  /// - Success: ApiResponse<ArticleListResponse>
  ///
  /// 异常:
  /// - NetworkException: 网络错误
  /// - ServerException: 服务器错误
  /// - ParseException: 解析错误
  Future<ApiResponse<ArticleListResponse>> fetchArticles(int page);
}

/// BlogRemoteDataSourceImpl: 博客远程数据源实现
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final ApiClient _apiClient;

  const BlogRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<BannerModel>>> fetchBanners() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/banner/json',
    );

    return ApiResponse.fromJson(
      response.data!,
      (json) {
        if (json == null) return <BannerModel>[];
        return (json as List)
            .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<ApiResponse<ArticleListResponse>> fetchArticles(int page) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/article/list/$page/json',
    );

    return ApiResponse.fromJson(
      response.data!,
      (json) => ArticleListResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
