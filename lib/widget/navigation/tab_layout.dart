import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_controller.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_item.dart';

/*
* 顶部导航组件
* @author JTech JH
* @Time 2022/4/1 16:22
*/
class JTabLayout extends BaseStatefulWidget {
  //导航控制器
  final NavigationController<NavigationItem> controller;

  //tab导航栏颜色
  final Color tabBarColor;

  //tab导航栏高度
  final double tabBarHeight;

  //tab导航栏悬浮高度
  final double elevation;

  //导航栏tab是否可滚动
  final bool isFixed;

  //导航容器形状
  final ShapeBorder shape;

  //外间距
  final EdgeInsetsGeometry margin;

  //选中文本颜色
  final Color? labelColor;

  //为选中文本颜色
  final Color? unselectedLabelColor;

  //指示器样式
  final Decoration? indicator;

  //指示器颜色
  final Color? indicatorColor;

  //指示器内间距
  final EdgeInsetsGeometry indicatorPadding;

  //指示器厚度
  final double indicatorWeight;

  //指示器尺寸
  final TabBarIndicatorSize? indicatorSize;

  const JTabLayout({
    Key? key,
    required this.controller,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicator,
    this.indicatorSize,
    this.indicatorColor,
    this.tabBarHeight = 55,
    Color? tabBarColor,
    double? elevation,
    bool? isFixed,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
    EdgeInsetsGeometry? indicatorPadding,
    double? indicatorWeight,
  })  : tabBarColor = tabBarColor ?? Colors.transparent,
        elevation = elevation ?? 0,
        isFixed = isFixed ?? true,
        margin = margin ?? EdgeInsets.zero,
        shape = shape ?? const RoundedRectangleBorder(),
        indicatorPadding = indicatorPadding ?? EdgeInsets.zero,
        indicatorWeight = indicatorWeight ?? 2.0,
        super(key: key);

  //构建标题栏底部结构导航栏
  static PreferredSize appBarBottom({
    required NavigationController<NavigationItem> controller,
    Color? tabBarColor,
    double tabBarHeight = 55,
    double? elevation,
    bool? isFixed,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    Color? labelColor,
    Color? unselectedLabelColor,
    Decoration? indicator,
    Color? indicatorColor,
    EdgeInsetsGeometry? indicatorPadding,
    double? indicatorWeight,
    TabBarIndicatorSize? indicatorSize,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(tabBarHeight),
      child: JTabLayout(
        controller: controller,
        labelColor: labelColor,
        unselectedLabelColor: unselectedLabelColor,
        indicator: indicator,
        indicatorSize: indicatorSize,
        indicatorColor: indicatorColor,
        tabBarColor: tabBarColor,
        tabBarHeight: tabBarHeight,
        elevation: elevation,
        isFixed: isFixed,
        margin: margin,
        shape: shape,
        indicatorPadding: indicatorPadding,
        indicatorWeight: indicatorWeight,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _JTabLayoutState();
}

/*
* 顶部导航组件-状态
* @author JTech JH
* @Time 2022/4/1 16:23
*/
class _JTabLayoutState extends BaseState<JTabLayout>
    with SingleTickerProviderStateMixin {
  //顶部导航控制器
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    //初始化顶部导航控制器
    tabController = TabController(
      length: widget.controller.itemLength,
      vsync: this,
      initialIndex: widget.controller.value,
    );
    //监听页码下标变化
    widget.controller.addListener(() {
      var currentIndex = widget.controller.value;
      if (currentIndex != tabController.index) {
        tabController.animateTo(currentIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.controller,
      builder: (_, i, child) {
        return TabBar(
          controller: tabController,
          labelColor: widget.labelColor,
          unselectedLabelColor: widget.unselectedLabelColor,
          isScrollable: !widget.isFixed,
          indicator: widget.indicator,
          indicatorColor: widget.indicatorColor,
          indicatorPadding: widget.indicatorPadding,
          indicatorWeight: widget.indicatorWeight,
          indicatorSize: widget.indicatorSize,
          onTap: (index) => widget.controller.select(index),
          tabs: List.generate(
              widget.controller.itemLength, (index) => _buildTabBarItem(index)),
        );
      },
    );
  }

  //构建tabBar子项
  _buildTabBarItem(int index) {
    var item = widget.controller.getItem(index);
    bool selected = index == widget.controller.value;
    return Container(
      height: widget.tabBarHeight,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          (selected ? item.activeIcon : item.icon) ?? const EmptyBox(),
          (selected ? item.activeTitle : item.title) ?? const EmptyBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //销毁控制器
    tabController.dispose();
    super.dispose();
  }
}
