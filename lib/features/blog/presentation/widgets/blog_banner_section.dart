import 'package:flutter/material.dart';
import '../../data/models/banner_model.dart';

/// 博客Banner区域组件
///
/// 参考FlutterPlay的最新资讯Banner设计
/// 特性:
/// 1. 整体圆角白色背景卡片
/// 2. 顶部"最新资讯"标题 + "查看更多"按钮
/// 3. 中间轮播图微放大效果
/// 4. 文章标题在底部居中
/// 5. 底部圆点指示器
class BlogBannerSection extends StatefulWidget {
  final List<BannerModel> banners;
  final VoidCallback? onViewMore;

  const BlogBannerSection({
    super.key,
    required this.banners,
    this.onViewMore,
  });

  @override
  State<BlogBannerSection> createState() => _BlogBannerSectionState();
}

class _BlogBannerSectionState extends State<BlogBannerSection> {
  late PageController _pageController;
  int _currentPage = 1; // 从中间开始,确保初始状态下中间项是放大的
  double _currentPageValue = 1.0;

  @override
  void initState() {
    super.initState();
    // viewportFraction 设置为 0.35，让左右两侧的卡片都可见
    _pageController = PageController(
      viewportFraction: 0.35,
      initialPage: _currentPage,
    );

    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? _currentPage.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部标题栏
          _buildHeader(context),

          // 轮播图区域
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                return _buildBannerItem(index);
              },
            ),
          ),

          const SizedBox(height: 12),

          // 当前Banner的标题
          _buildCurrentBannerTitle(),

          const SizedBox(height: 12),

          // 圆点指示器
          _buildIndicator(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// 构建顶部标题栏
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '最新资讯',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: widget.onViewMore,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '查看更多',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: theme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建单个Banner项
  Widget _buildBannerItem(int index) {
    final banner = widget.banners[index];

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        // 计算缩放比例
        double scale = 1.0;
        if (_pageController.position.haveDimensions) {
          final page = _currentPageValue;
          // 计算当前item与中心位置的距离
          final distance = (page - index).abs();

          // 中间的item放大到1.1，两侧的缩小到0.9
          if (distance < 1) {
            scale = 1.0 + (0.1 * (1 - distance));
          } else {
            scale = 0.9;
          }
        } else if (_currentPage == index) {
          scale = 1.1;
        } else {
          scale = 0.9;
        }

        return Center(
          child: Transform.scale(
            scale: scale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              // 设置合适的宽高比 (16:9 常见Banner比例)
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    banner.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建当前Banner的标题
  Widget _buildCurrentBannerTitle() {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentBanner = widget.banners[_currentPage];
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            currentBanner.title,
            key: ValueKey(_currentPage),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// 构建圆点指示器
  Widget _buildIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.banners.length,
            (index) {
              final isActive = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 20 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
