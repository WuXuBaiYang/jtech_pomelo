import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/util/util.dart';
import 'package:jtech_pomelo/widget/listview/index/controller.dart';
import 'package:jtech_pomelo/widget/listview/index/model.dart';

/*
* 索引列表组件
* @author JTech JH
* @Time 2022/4/7 14:55
*/
class JIndexListView<V extends BaseIndexModel> extends BaseStatefulWidget {
  //列表控制器
  final IndexListViewController<V> controller;

  //列表项构造器
  final ItemBuilder<V> itemBuilder;

  //内间距
  final EdgeInsets? padding;

  //列表项点击事件
  final ItemTap<V>? itemTap;

  //列表项长点击事件
  final ItemTap<V>? itemLongPress;

  //弹出提示框子项构造
  final ItemBuilder<V>? susItemBuilder;

  //提示框高度
  final double susItemHeight;

  //位置
  final Offset? susPosition;

  //索引条提示构造器
  final IndexHintBuilder? indexHintBuilder;

  //索引条数据
  final List<String> indexBarData;

  //索引条宽度
  final double indexBarWidth;

  //索引条高度
  final double? indexBarHeight;

  //索引条子项高度
  final double indexBarItemHeight;

  //触觉反馈
  final bool hapticFeedback;

  //索引条位置
  final AlignmentGeometry indexBarAlignment;

  //索引条外间距
  final EdgeInsetsGeometry? indexBarMargin;

  //索引条配置
  final IndexBarOptions indexBarOptions;

  //索引是否从数据中提取
  final bool indexFromData;

  const JIndexListView({
    Key? key,
    required this.itemBuilder,
    required this.controller,
    this.itemTap,
    this.itemLongPress,
    this.padding,
    //弹出框参数
    this.susItemBuilder,
    this.susPosition,
    double? susItemHeight,
    //索引条参数
    this.indexHintBuilder,
    this.indexBarMargin,
    this.indexBarHeight,
    List<String>? indexBarData,
    double? indexBarWidth,
    double? indexBarItemHeight,
    bool? hapticFeedback,
    AlignmentGeometry? indexBarAlignment,
    IndexBarOptions? indexBarOptions,
    bool? indexFromData,
  })  : susItemHeight = susItemHeight ?? kSusItemHeight,
        indexBarData = indexBarData ?? kIndexBarData,
        indexBarWidth = indexBarWidth ?? kIndexBarWidth,
        indexBarItemHeight = indexBarItemHeight ?? kIndexBarItemHeight,
        hapticFeedback = hapticFeedback ?? false,
        indexBarAlignment = indexBarAlignment ?? Alignment.centerRight,
        indexBarOptions = indexBarOptions ?? const IndexBarOptions(),
        indexFromData = indexFromData ?? false,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JIndexListViewState<V>();
}

/*
* 索引列表组件-状态
* @author JTech JH
* @Time 2022/4/7 14:55
*/
class _JIndexListViewState<V extends BaseIndexModel>
    extends BaseState<JIndexListView<V>> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<V>>(
      valueListenable: widget.controller,
      builder: (_, dataList, child) {
        return AzListView(
          data: dataList,
          physics: const BouncingScrollPhysics(),
          itemCount: dataList.length,
          padding: widget.padding,
          itemBuilder: (_, index) =>
              _buildListItem(context, dataList[index], index),
          //设置弹出提示参数
          susItemHeight: widget.susItemHeight,
          susPosition: widget.susPosition,
          susItemBuilder: (_, index) =>
              _buildSusItem(context, dataList[index], index),
          //侧边索引条参数
          indexBarData: widget.indexFromData
              ? widget.controller.indexDataList
              : widget.indexBarData,
          indexBarWidth: widget.indexBarWidth,
          indexBarHeight: widget.indexBarHeight,
          indexBarItemHeight: widget.indexBarItemHeight,
          indexBarAlignment: widget.indexBarAlignment,
          indexBarMargin: widget.indexBarMargin,
          indexBarOptions: widget.indexBarOptions,
          indexHintBuilder: _buildIndexBarHint,
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

  //构建列表内标头项
  Widget _buildSusItem(BuildContext context, V item, int index) {
    return widget.susItemBuilder?.call(context, item, index) ??
        _buildDefSusItem(context, item);
  }

  //构建默认列表内标头项
  Widget _buildDefSusItem(BuildContext context, V item) {
    return Container(
      width: JUtil.getScreenWith(context),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      color: Colors.grey[200],
      child: Text(
        item.tagIndex,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  //构建索引条弹出提出项
  Widget _buildIndexBarHint(BuildContext context, String tag) {
    return widget.indexHintBuilder?.call(context, tag) ??
        _buildDefIndexBarHint(tag);
  }

  //构建索引条默认弹出提示框
  Widget _buildDefIndexBarHint(String tag) {
    var options = widget.indexBarOptions;
    return Container(
      width: options.indexHintWidth,
      height: options.indexHintHeight,
      decoration: options.indexHintDecoration,
      alignment: options.indexHintChildAlignment,
      child: Text(tag, style: options.indexHintTextStyle),
    );
  }
}
