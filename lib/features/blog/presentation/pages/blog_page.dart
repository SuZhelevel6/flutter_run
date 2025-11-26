import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_run/core/l10n/l10n.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/blog_remote_datasource.dart';
import '../../data/repositories/blog_repository_impl.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';
import '../widgets/blog_banner_section.dart';
import '../widgets/article_card.dart';

/// Blog 文章页
///
/// 展示技术文章和博客内容
///
/// 功能:
/// 1. Banner 轮播图
/// 2. 文章网格列表
/// 3. 下拉刷新
/// 4. 上拉加载更多
class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc(
        BlogRepositoryImpl(
          BlogRemoteDataSourceImpl(ApiClient()),
        ),
      )..add(const LoadBlogData()),
      child: const _BlogContent(),
    );
  }
}

class _BlogContent extends StatefulWidget {
  const _BlogContent();

  @override
  State<_BlogContent> createState() => _BlogContentState();
}

class _BlogContentState extends State<_BlogContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 监听滚动事件,实现上拉加载更多
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动监听,实现上拉加载更多
  void _onScroll() {
    if (_isBottom) {
      context.read<BlogBloc>().add(const LoadMoreArticles());
    }
  }

  /// 判断是否滚动到底部
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navBlog),
        centerTitle: true,
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          return switch (state) {
            BlogInitial() => const SizedBox.shrink(),
            BlogLoading() => const Center(child: CircularProgressIndicator()),
            BlogLoaded(:final banners, :final articles, :final isLoadingMore) =>
              RefreshIndicator(
                onRefresh: () async {
                  context.read<BlogBloc>().add(const RefreshBlogData());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Banner 轮播图
                    if (banners.isNotEmpty)
                      SliverToBoxAdapter(
                        child: BlogBannerSection(
                          banners: banners,
                          onViewMore: () {
                            // TODO: 实现查看更多功能
                            debugPrint('查看更多资讯');
                          },
                        ),
                      ),

                    // 文章网格
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2.5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= articles.length) {
                              return isLoadingMore
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const SizedBox.shrink();
                            }
                            final article = articles[index];
                            return ArticleCard(
                              article: article,
                              onTap: () {
                                // TODO: 实现文章详情页跳转
                                debugPrint('打开文章: ${article.title}');
                              },
                            );
                          },
                          childCount: articles.length + (isLoadingMore ? 1 : 0),
                        ),
                      ),
                    ),

                    // 底部留白
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                  ],
                ),
              ),
            BlogError(:final message, :final canRetry) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(message, textAlign: TextAlign.center),
                    if (canRetry) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<BlogBloc>().add(const LoadBlogData()),
                        child: const Text('重试'),
                      ),
                    ],
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}
