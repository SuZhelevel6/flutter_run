import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 会议工作台骨架屏组件
///
/// 在数据加载时显示，模拟真实内容布局，提升用户体验
///
/// 技术要点：
/// - **Shimmer 效果**：使用 shimmer 包实现闪烁加载动画
/// - **布局一致性**：骨架屏结构与真实内容结构一致，减少布局跳动
/// - **视觉层次**：通过不同的占位块大小表达内容层次
/// - **主题适配**：根据当前主题自动调整骨架屏颜色
///
/// 问题场景：
/// 原实现使用单调的 CircularProgressIndicator，用户无法预知页面结构，
/// 加载完成后布局跳动明显，体验较差。
///
/// 解决方案：
/// 使用骨架屏模拟真实页面结构，让用户在加载时就能预知内容布局，
/// 加载完成后平滑过渡，减少视觉跳动。
class WorkspaceSkeleton extends StatelessWidget {
  const WorkspaceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 根据主题选择骨架屏颜色
    final baseColor = isDark
        ? Colors.grey.shade800
        : Colors.grey.shade300;
    final highlightColor = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 问候语头部骨架
              const _GreetingHeaderSkeleton(),

              // 快捷入口骨架
              const _QuickActionsSkeleton(),

              // 分隔线
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: _SkeletonBox(height: 1, width: double.infinity),
              ),

              // 会议列表标题骨架
              const _SectionTitleSkeleton(),

              // 日期头部骨架
              const _DateHeaderSkeleton(),

              // 会议卡片骨架（显示 3 张）
              for (int i = 0; i < 3; i++) const _MeetingCardSkeleton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 问候语头部骨架
class _GreetingHeaderSkeleton extends StatelessWidget {
  const _GreetingHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧：问候语和会议数量
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 问候语占位
                Row(
                  children: [
                    const _SkeletonBox(width: 32, height: 32, isCircle: true),
                    const SizedBox(width: 8),
                    _SkeletonBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 会议数量占位
                const _SkeletonBox(width: 150, height: 16),
              ],
            ),
          ),

          // 右侧：时间显示
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SkeletonBox(width: 80, height: 32),
              SizedBox(height: 4),
              _SkeletonBox(width: 100, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

/// 快捷入口骨架
class _QuickActionsSkeleton extends StatelessWidget {
  const _QuickActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          4,
          (index) => const Column(
            children: [
              _SkeletonBox(width: 56, height: 56, borderRadius: 16),
              SizedBox(height: 8),
              _SkeletonBox(width: 48, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// 区域标题骨架
class _SectionTitleSkeleton extends StatelessWidget {
  const _SectionTitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          _SkeletonBox(width: 20, height: 20, isCircle: true),
          SizedBox(width: 8),
          _SkeletonBox(width: 80, height: 18),
        ],
      ),
    );
  }
}

/// 日期头部骨架
class _DateHeaderSkeleton extends StatelessWidget {
  const _DateHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        children: [
          _SkeletonBox(width: 18, height: 18, isCircle: true),
          SizedBox(width: 8),
          _SkeletonBox(width: 80, height: 18),
          SizedBox(width: 8),
          _SkeletonBox(width: 60, height: 14),
          Spacer(),
          _SkeletonBox(width: 40, height: 20, borderRadius: 12),
        ],
      ),
    );
  }
}

/// 会议卡片骨架
class _MeetingCardSkeleton extends StatelessWidget {
  const _MeetingCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：状态标签 + 时间
          Row(
            children: [
              _SkeletonBox(width: 56, height: 24, borderRadius: 4),
              SizedBox(width: 12),
              _SkeletonBox(width: 16, height: 16, isCircle: true),
              SizedBox(width: 4),
              _SkeletonBox(width: 100, height: 14),
              Spacer(),
              _SkeletonBox(width: 50, height: 20, borderRadius: 4),
            ],
          ),
          SizedBox(height: 12),

          // 第二行：会议标题
          _SkeletonBox(width: double.infinity, height: 20),
          SizedBox(height: 4),
          _SkeletonBox(width: 200, height: 20),
          SizedBox(height: 8),

          // 第三行：会议室
          Row(
            children: [
              _SkeletonBox(width: 16, height: 16, isCircle: true),
              SizedBox(width: 4),
              _SkeletonBox(width: 80, height: 14),
            ],
          ),
          SizedBox(height: 8),

          // 第四行：参会人
          Row(
            children: [
              // 头像堆叠
              _AvatarStackSkeleton(),
              SizedBox(width: 8),
              _SkeletonBox(width: 120, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

/// 头像堆叠骨架
class _AvatarStackSkeleton extends StatelessWidget {
  const _AvatarStackSkeleton();

  @override
  Widget build(BuildContext context) {
    const avatarSize = 28.0;
    const overlap = 8.0;
    const count = 3;

    return SizedBox(
      width: avatarSize + (count - 1) * (avatarSize - overlap),
      height: avatarSize,
      child: Stack(
        children: List.generate(
          count,
          (index) => Positioned(
            left: index * (avatarSize - overlap),
            child: const _SkeletonBox(
              width: avatarSize,
              height: avatarSize,
              isCircle: true,
            ),
          ),
        ),
      ),
    );
  }
}

/// 骨架占位块
///
/// 基础骨架组件，用于构建各种占位元素
class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = 4,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}
