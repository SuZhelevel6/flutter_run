import 'package:equatable/equatable.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/article_model.dart';

/// BlogState: 博客状态
///
/// 使用 sealed class 确保类型安全
sealed class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

/// BlogInitial: 初始状态
class BlogInitial extends BlogState {
  const BlogInitial();
}

/// BlogLoading: 加载中状态
class BlogLoading extends BlogState {
  const BlogLoading();
}

/// BlogLoaded: 数据加载成功状态
class BlogLoaded extends BlogState {
  /// 轮播图列表
  final List<BannerModel> banners;

  /// 文章列表
  final List<ArticleModel> articles;

  /// 当前页码
  final int currentPage;

  /// 是否还有更多数据
  final bool hasMore;

  /// 是否正在加载更多
  final bool isLoadingMore;

  const BlogLoaded({
    required this.banners,
    required this.articles,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  /// 复制状态
  BlogLoaded copyWith({
    List<BannerModel>? banners,
    List<ArticleModel>? articles,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return BlogLoaded(
      banners: banners ?? this.banners,
      articles: articles ?? this.articles,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        banners,
        articles,
        currentPage,
        hasMore,
        isLoadingMore,
      ];
}

/// BlogError: 错误状态
class BlogError extends BlogState {
  /// 错误信息
  final String message;

  /// 是否可以重试
  final bool canRetry;

  const BlogError(this.message, {this.canRetry = true});

  @override
  List<Object?> get props => [message, canRetry];
}
