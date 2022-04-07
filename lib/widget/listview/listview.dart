import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/listview/controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//数据加载
typedef ListRefreshLoad<V> = Future<List<V>> Function(
    int pageIndex, int pageSize, bool loadMore);

/*
* 列表组件
* @author JTech JH
* @Time 2022/4/7 13:36
*/
class JListView<V> extends BaseStatefulWidget {
  //列表控制器
  final ListViewController<V>? controller;

  //集合数据加载回调
  final ListRefreshLoad<V>? refreshLoad;

  //列表项构造器
  final ItemBuilder<V> itemBuilder;

  //分割线构造器
  final ItemBuilder<V>? separatorBuilder;

  //收缩内容
  final bool shrinkWrap;

  //是否可滚动
  final bool canScroll;

  //内间距
  final EdgeInsetsGeometry? padding;

  //缓存高度
  final double? cacheExtent;

  //列表项点击事件
  final ItemTap<V>? itemTap;

  //列表项长点击事件
  final ItemTap<V>? itemLongPress;

  //启用下拉刷新
  final bool enablePullDown;

  //启用上拉加载
  final bool enablePullUp;

  //下拉刷新头部指示器
  final Widget header;

  //上拉加载足部指示器
  final Widget footer;

  const JListView({
    Key? key,
    required this.itemBuilder,
    this.refreshLoad,
    this.controller,
    this.itemTap,
    this.itemLongPress,
    this.separatorBuilder,
    this.padding,
    this.cacheExtent,
    bool? shrinkWrap,
    bool? canScroll,
    bool? enablePullDown,
    bool? enablePullUp,
    Widget? header,
    Widget? footer,
  })  : shrinkWrap = shrinkWrap ?? false,
        canScroll = canScroll ?? true,
        enablePullDown = enablePullDown ?? false,
        enablePullUp = enablePullUp ?? false,
        header = header ?? const ClassicHeader(),
        footer = footer ?? const ClassicFooter(),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JListViewState<V>();
}

/*
* 列表组件-状态
* @author JTech JH
* @Time 2022/4/7 13:37
*/
class _JListViewState<V> extends BaseState<JListView<V>> {
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
          child: ListView.separated(
            physics: scrollPhysics,
            padding: widget.padding,
            itemCount: controller.length,
            cacheExtent: widget.cacheExtent,
            itemBuilder: (_, index) =>
                _buildListItem(context, dataList[index], index),
            separatorBuilder: (_, index) =>
                _buildListSeparator(context, dataList[index], index),
          ),
        );
      },
    );
  }

  //构建列表子项
  Widget _buildListItem(BuildContext context, V item, int index) {
    return InkWell(
      child: widget.itemBuilder(context, item, index),
      onTap: null != widget.itemTap ? () => widget.itemTap!(item, index) : null,
      onLongPress: null != widget.itemLongPress
          ? () => widget.itemLongPress!(item, index)
          : null,
    );
  }

  //构造分割线
  Widget _buildListSeparator(BuildContext context, V item, int index) {
    return widget.separatorBuilder?.call(context, item, index) ??
        const EmptyBox();
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
  ListViewController<V>? _controller;

  //获取控制器对象
  ListViewController<V> get controller =>
      widget.controller ?? (_controller ??= ListViewController());

  @override
  void dispose() {
    //销毁控制器
    controller.dispose();
    super.dispose();
  }
}
