import 'package:equatable/equatable.dart';

/// BlogEvent: 博客事件
///
/// 使用 sealed class 确保类型安全
sealed class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

/// LoadBlogData: 加载博客数据
///
/// 同时加载轮播图和文章列表
class LoadBlogData extends BlogEvent {
  const LoadBlogData();
}

/// RefreshBlogData: 刷新博客数据
///
/// 重新加载轮播图和第一页文章
class RefreshBlogData extends BlogEvent {
  const RefreshBlogData();
}

/// LoadMoreArticles: 加载更多文章
///
/// 加载下一页文章数据
class LoadMoreArticles extends BlogEvent {
  const LoadMoreArticles();
}
