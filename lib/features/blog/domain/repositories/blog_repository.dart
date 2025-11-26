import '../../../../core/network/result.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/article_model.dart';

/// BlogRepository: 博客数据仓库接口
///
/// 定义博客模块的数据访问接口,遵循依赖倒置原则:
/// - Presentation 层和 Domain 层依赖此接口
/// - Data 层实现此接口
///
/// 使用 Result 类型确保类型安全的错误处理
abstract class BlogRepository {
  /// 获取轮播图列表
  ///
  /// 返回:
  /// - Success<List<BannerModel>>: 成功获取轮播图列表
  /// - Failure<NetworkFailure>: 网络错误
  /// - Failure<ServerFailure>: 服务器错误
  /// - Failure<BusinessFailure>: 业务错误
  /// - Failure<ParseFailure>: 数据解析错误
  /// - Failure<UnknownFailure>: 未知错误
  ///
  /// 使用示例:
  /// ```dart
  /// final result = await repository.getBanners();
  ///
  /// result.when(
  ///   success: (banners) {
  ///     // 处理成功情况
  ///     print('获取到 ${banners.length} 个轮播图');
  ///   },
  ///   failure: (error) {
  ///     // 处理错误情况
  ///     if (error is NetworkFailure) {
  ///       showRetryDialog();
  ///     }
  ///   },
  /// );
  /// ```
  Future<Result<List<BannerModel>>> getBanners();

  /// 获取文章列表
  ///
  /// 参数:
  /// - [page]: 页码 (从 0 开始)
  ///
  /// 返回:
  /// - Success<List<ArticleModel>>: 成功获取文章列表
  /// - Failure<NetworkFailure>: 网络错误
  /// - Failure<ServerFailure>: 服务器错误
  /// - Failure<BusinessFailure>: 业务错误
  /// - Failure<ParseFailure>: 数据解析错误
  /// - Failure<UnknownFailure>: 未知错误
  ///
  /// 使用示例:
  /// ```dart
  /// final result = await repository.getArticles(0);
  ///
  /// result.when(
  ///   success: (articles) {
  ///     // 处理成功情况
  ///     print('获取到 ${articles.length} 篇文章');
  ///   },
  ///   failure: (error) {
  ///     // 处理错误情况
  ///     showErrorMessage(error.message);
  ///   },
  /// );
  /// ```
  Future<Result<List<ArticleModel>>> getArticles(int page);
}
