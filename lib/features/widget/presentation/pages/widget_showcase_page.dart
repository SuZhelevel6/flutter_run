import 'package:flutter/material.dart';
import '../../data/mock_widget_data.dart';
import '../../domain/models/widget_category.dart';
import '../../domain/models/widget_info.dart';
import '../widgets/widget_card.dart';
import 'widget_detail_page.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Widget 集录主页面
///
/// 使用 TabBar + TabBarView 展示不同分类的组件
class WidgetShowcasePage extends StatefulWidget {
  const WidgetShowcasePage({super.key});

  @override
  State<WidgetShowcasePage> createState() => _WidgetShowcasePageState();
}

class _WidgetShowcasePageState extends State<WidgetShowcasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<WidgetCategory> _categories = MockWidgetData.getAllCategories();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navWidget),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: _categories.map((category) {
            return Tab(
              text: _getCategoryName(category),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _CategoryView(category: category);
        }).toList(),
      ),
    );
  }

  /// 获取分类名称
  String _getCategoryName(WidgetCategory category) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case WidgetCategory.stateless:
        return l10n.widgetCategoryStateless;
      case WidgetCategory.stateful:
        return l10n.widgetCategoryStateful;
      case WidgetCategory.other:
        return l10n.widgetCategoryOther;
    }
  }
}

/// 分类视图
class _CategoryView extends StatelessWidget {
  final WidgetCategory category;

  const _CategoryView({required this.category});

  @override
  Widget build(BuildContext context) {
    final widgets = MockWidgetData.getWidgetsByCategory(category);

    if (widgets.isEmpty) {
      return _EmptyView(category: category);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // 计算列数 - 响应式布局
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            final widget = widgets[index];
            return WidgetCard(
              widgetInfo: widget,
              onTap: () => _navigateToDetail(context, widget),
            );
          },
        );
      },
    );
  }

  /// 计算网格列数（响应式）
  int _calculateCrossAxisCount(double width) {
    if (width >= 1200) {
      return 4; // 超大屏幕
    } else if (width >= 900) {
      return 3; // 大屏幕
    } else if (width >= 600) {
      return 2; // 中屏幕
    } else {
      return 2; // 小屏幕
    }
  }

  /// 导航到详情页
  void _navigateToDetail(BuildContext context, WidgetInfo widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WidgetDetailPage(widgetInfo: widget),
      ),
    );
  }
}

/// 空视图
class _EmptyView extends StatelessWidget {
  final WidgetCategory category;

  const _EmptyView({required this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.widgets_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noWidgets,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
