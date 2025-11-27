import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/result.dart';
import '../../data/models/banner_model.dart';
import '../../domain/repositories/blog_repository.dart';
import 'blog_event.dart';
import 'blog_state.dart';

/// BlogBloc: 博客业务逻辑组件
///
/// 职责:
/// 1. 接收 UI 事件 (BlogEvent)
/// 2. 调用 Repository 获取数据
/// 3. 处理结果并发出新状态 (BlogState)
/// 4. 管理分页加载逻辑
///
///工作流程：
///1. UI 调用 bloc.add(LoadBlogData())
///       ↓
///2. BLoC 接收到事件，查找事件类型
///       ↓
///3. 发现是 LoadBlogData 类型
///       ↓
///4. 根据 on<LoadBlogData>(_onLoadBlogData) 注册关系
///       ↓
///5. 调用 _onLoadBlogData 方法处理
///       ↓
///6. _onLoadBlogData 执行业务逻辑，发出新状态
///       ↓
///7. UI 监听到新状态，更新界面
/// ```
class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository _repository;

  //创建 BlogBloc 时必须传入一个 Repository 实例，初始化状态是BlogInitial
  BlogBloc(this._repository) : super(const BlogInitial()) {
    on<LoadBlogData>(_onLoadBlogData);
    on<RefreshBlogData>(_onRefreshBlogData);
    on<LoadMoreArticles>(_onLoadMoreArticles);
    //  ↑ 泛型指定事件类型    ↑ 处理这个事件的方法
  }

  /// 处理加载博客数据事件
  Future<void> _onLoadBlogData(
    LoadBlogData event,
    Emitter<BlogState> emit,
  ) async {
    emit(const BlogLoading());

    // 并发加载轮播图和第一页文章
    final bannersResult = await _repository.getBanners();
    final articlesResult = await _repository.getArticles(0);

    // 处理轮播图结果
    final banners = bannersResult.when(
      success: (data) => data,
      failure: (error) => <BannerModel>[],
    );

    // 处理文章结果
    articlesResult.when(
      success: (articles) {
        emit(BlogLoaded(
          banners: banners,
          articles: articles,
          currentPage: 0,
          hasMore: articles.isNotEmpty,
        ));
      },
      failure: (error) {
        emit(BlogError(
          _getErrorMessage(error),
          canRetry: _canRetry(error),
        ));
      },
    );
  }

  /// 处理刷新博客数据事件
  Future<void> _onRefreshBlogData(
    RefreshBlogData event,
    Emitter<BlogState> emit,
  ) async {
    // 刷新时重新加载数据
    add(const LoadBlogData());
  }

  /// 处理加载更多文章事件
  Future<void> _onLoadMoreArticles(
    LoadMoreArticles event,
    Emitter<BlogState> emit,
  ) async {
    final currentState = state;

    // 只有在 BlogLoaded 状态下才能加载更多
    if (currentState is! BlogLoaded) return;

    // 如果没有更多数据或正在加载,则不处理
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    // 标记正在加载更多
    emit(currentState.copyWith(isLoadingMore: true));

    // 加载下一页
    final nextPage = currentState.currentPage + 1;
    final result = await _repository.getArticles(nextPage);

    result.when(
      success: (newArticles) {
        emit(currentState.copyWith(
          articles: [...currentState.articles, ...newArticles],
          currentPage: nextPage,
          hasMore: newArticles.isNotEmpty,
          isLoadingMore: false,
        ));
      },
      failure: (error) {
        // 加载更多失败时,保持当前状态,取消加载标记
        emit(currentState.copyWith(isLoadingMore: false));
      },
    );
  }

  /// 根据 Failure 类型返回用户友好的错误信息
  String _getErrorMessage(AppFailure failure) {
    return switch (failure) {
      NetworkFailure() => '网络连接失败,请检查网络设置',
      ServerFailure(:final statusCode) when statusCode != null =>
        '服务器错误 ($statusCode),请稍后重试',
      ServerFailure() => '服务器错误,请稍后重试',
      BusinessFailure(:final message) => message,
      ParseFailure() => '数据解析失败,请稍后重试',
      _ => '未知错误,请稍后重试',
    };
  }

  /// 判断错误是否可以重试
  bool _canRetry(AppFailure failure) {
    return switch (failure) {
      NetworkFailure() => true, // 网络错误可以重试
      ServerFailure() => true, // 服务器错误可以重试
      _ => false, // 其他错误不建议重试
    };
  }
}
