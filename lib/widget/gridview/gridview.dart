import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/gridview/controller.dart';
import 'package:jtech_pomelo/widget/listview/listview.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
* 表格列表组件
* @author JTech JH
* @Time 2022/4/6 16:54
*/
class JGridView<V> extends BaseStatefulWidget {
  //控制器
  final GridViewController<V>? controller;

  //集合数据加载回调
  final ListRefreshLoad<V>? refreshLoad;

  //列表项构造器
  final ItemBuilder<V> itemBuilder;

  //是否可滚动
  final bool canScroll;

  //内间距
  final EdgeInsetsGeometry padding;

  //子项点击事件
  final ItemTap<V>? itemTap;

  //子项长点击事件
  final ItemTap<V>? itemLongPress;

  //副方向上的最大元素数量
  final int crossAxisCount;

  //主方向元素间距
  final double mainAxisSpacing;

  //副方向元素间距
  final double crossAxisSpacing;

  //启用下拉刷新
  final bool enablePullDown;

  //启用上拉加载
  final bool enablePullUp;

  //下拉刷新头部指示器
  final Widget header;

  //上拉加载足部指示器
  final Widget footer;

  const JGridView({
    Key? key,
    required this.crossAxisCount,
    required this.itemBuilder,
    this.controller,
    this.refreshLoad,
    this.itemTap,
    this.itemLongPress,
    EdgeInsetsGeometry? padding,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    bool? canScroll,
    bool? enablePullDown,
    bool? enablePullUp,
    Widget? header,
    Widget? footer,
  })  : padding = padding ?? EdgeInsets.zero,
        mainAxisSpacing = mainAxisSpacing ?? 0.0,
        crossAxisSpacing = crossAxisSpacing ?? 0.0,
        canScroll = canScroll ?? true,
        enablePullDown = enablePullDown ?? false,
        enablePullUp = enablePullUp ?? false,
        header = header ?? const ClassicHeader(),
        footer = footer ?? const ClassicFooter(),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JGridViewState<V>();
}

/*
* 表格列表组件-状态
* @author JTech JH
* @Time 2022/4/6 16:54
*/
class _JGridViewState<V> extends BaseState<JGridView<V>> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<V>>(
      valueListenable: controller,
      builder: (_, dataList, child) {
        return SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: widget.enablePullDown,
          enablePullUp: widget.enablePullUp,
          onRefresh: () => _loadDataList(false),
          onLoading: () => _loadDataList(true),
          header: widget.header,
          footer: widget.footer,
          child: SingleChildScrollView(
            physics: scrollPhysics,
            padding: widget.padding,
            child: StaggeredGrid.count(
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
              crossAxisCount: widget.crossAxisCount,
              children: List.generate(dataList.length, (index) {
                return buildGridItem(context, dataList[index], index);
              }),
            ),
          ),
        );
      },
    );
  }

  //构建列表子项
  Widget buildGridItem(BuildContext context, V item, int index) {
    return InkWell(
      child: widget.itemBuilder(context, item, index),
      onTap: null != widget.itemTap ? () => widget.itemTap!(item, index) : null,
      onLongPress: null != widget.itemLongPress
          ? () => widget.itemLongPress!(item, index)
          : null,
    );
  }

  //加载数据集合
  void _loadDataList(bool loadMore) async {
    controller.resetRefreshState();
    try {
      var dataList = await widget.refreshLoad?.call(
        controller.getRequestPageIndex(loadMore),
        controller.pageSize,
        loadMore,
      );
      //执行加载完成操作
      controller.requestCompleted(dataList ?? [], loadMore: loadMore);
    } catch (e) {
      controller.requestFail(loadMore);
    }
  }

  //滚动控制
  ScrollPhysics? get scrollPhysics =>
      widget.canScroll ? null : const NeverScrollableScrollPhysics();

  //缓存控制器对象
  GridViewController<V>? _controller;

  //获取控制器对象
  GridViewController<V> get controller =>
      widget.controller ?? (_controller ??= GridViewController());

  @override
  void dispose() {
    //销毁控制器
    controller.dispose();
    super.dispose();
  }
}
