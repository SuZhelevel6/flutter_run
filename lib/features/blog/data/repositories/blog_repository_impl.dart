import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/result.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/blog_remote_datasource.dart';
import '../models/banner_model.dart';
import '../models/article_model.dart';

/// BlogRepositoryImpl: 博客数据仓库实现
///
/// 职责:
/// 1. 调用 DataSource 获取数据
/// 2. 将 Exception 转换为 Failure
/// 3. 将结果包装为 Result 类型
/// 4. 处理业务逻辑 (如缓存策略、数据合并等)
///
/// 错误处理流程:
/// ```
/// DataSource 抛出 Exception
///       ↓
/// Repository 捕获 Exception
///       ↓
/// Repository 转换为 Failure
///       ↓
/// Repository 返回 Result<Failure>
///       ↓
/// Bloc 处理 Result
/// ```
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _remoteDataSource;

  const BlogRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<BannerModel>>> getBanners() async {
    try {
      // 1. 从远程数据源获取数据
      final response = await _remoteDataSource.fetchBanners();

      // 2. 检查业务错误码
      if (response.isSuccess) {
        return Success(response.data);
      } else {
        return Failure(BusinessFailure(
          response.errorMsg,
          response.errorCode,
        ));
      }
    } on NetworkException catch (e) {
      // 3. 网络异常 → NetworkFailure
      return Failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      // 4. 服务器异常 → ServerFailure
      return Failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on ParseException catch (e) {
      // 5. 解析异常 → ParseFailure
      return Failure(ParseFailure(e.message));
    } catch (e) {
      // 6. 未知异常 → UnknownFailure
      return Failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ArticleModel>>> getArticles(int page) async {
    try {
      // 1. 从远程数据源获取数据
      final response = await _remoteDataSource.fetchArticles(page);

      // 2. 检查业务错误码
      if (response.isSuccess) {
        return Success(response.data.datas);
      } else {
        return Failure(BusinessFailure(
          response.errorMsg,
          response.errorCode,
        ));
      }
    } on NetworkException catch (e) {
      // 3. 网络异常 → NetworkFailure
      return Failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      // 4. 服务器异常 → ServerFailure
      return Failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on ParseException catch (e) {
      // 5. 解析异常 → ParseFailure
      return Failure(ParseFailure(e.message));
    } catch (e) {
      // 6. 未知异常 → UnknownFailure
      return Failure(UnknownFailure(e.toString()));
    }
  }
}
