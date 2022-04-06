import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/gridview/controller.dart';

/*
* 表格列表组件
* @author JTech JH
* @Time 2022/4/6 16:54
*/
class JGridView<V> extends BaseStatefulWidget {
  //控制器
  final GridViewController<V> controller;

  //副方向上的最大元素数量
  final int crossAxisCount;

  //列表项构造器
  final ItemBuilder<V> itemBuilder;

  //是否可滚动
  final bool canScroll;

  //子项点击事件
  final ItemTap<V>? itemTap;

  //子项长点击事件
  final ItemTap<V>? itemLongPress;

  //内间距
  final EdgeInsetsGeometry padding;

  //主方向元素间距
  final double mainAxisSpacing;

  //副方向元素间距
  final double crossAxisSpacing;

  const JGridView({
    Key? key,
    required this.crossAxisCount,
    required this.itemBuilder,
    required this.controller,
    this.itemTap,
    this.itemLongPress,
    EdgeInsetsGeometry? padding,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    bool? canScroll,
  })  : padding = padding ?? EdgeInsets.zero,
        mainAxisSpacing = mainAxisSpacing ?? 0.0,
        crossAxisSpacing = crossAxisSpacing ?? 0.0,
        canScroll = canScroll ?? true,
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
    return Padding(
      padding: widget.padding,
      child: ValueListenableBuilder<List<V>>(
        valueListenable: widget.controller,
        builder: (context, dataList, child) {
          return SingleChildScrollView(
            physics: scrollPhysics,
            child: StaggeredGrid.count(
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
              crossAxisCount: widget.crossAxisCount,
              children: List.generate(widget.controller.length, (index) {
                return buildItem(
                    context, widget.controller.getItem(index)!, index);
              }),
            ),
          );
        },
      ),
    );
  }

  //构建列表子项
  Widget buildItem(BuildContext context, V item, int index) {
    return InkWell(
      child: widget.itemBuilder(context, item, index),
      onTap: null != widget.itemTap ? () => widget.itemTap!(item, index) : null,
      onLongPress: null != widget.itemLongPress
          ? () => widget.itemLongPress!(item, index)
          : null,
    );
  }

  //滚动控制
  ScrollPhysics? get scrollPhysics =>
      widget.canScroll ? null : const NeverScrollableScrollPhysics();
}
