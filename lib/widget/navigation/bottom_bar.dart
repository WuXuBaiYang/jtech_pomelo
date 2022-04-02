import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/util/util.dart';
import 'package:jtech_pomelo/widget/badge/badge.dart';
import 'package:jtech_pomelo/widget/badge/badger.dart';
import 'package:jtech_pomelo/widget/badge/controller.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_controller.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_item.dart';

/*
* 底部导航组件
* @author JTech JH
* @Time 2022/4/2 9:25
*/
class JBottomBar extends BaseStatefulWidget {
  //导航控制器
  final NavigationController<NavigationItem> controller;

  //导航条颜色
  final Color? navigationColor;

  //导航条高度
  final double navigationHeight;

  //导航条悬浮高度
  final double? elevation;

  //notch的显示位置
  final NotchLocation notchLocation;

  //notch外间距
  final double notchMargin;

  //notch形状样式
  final NotchedShape? notchedShape;

  //子项内间距
  final EdgeInsetsGeometry itemPadding;

  //角标组件配置
  final JBadger badger;

  const JBottomBar({
    Key? key,
    //角标参数
    JBadger? badger,
    //基础参数
    required this.controller,
    this.navigationHeight = 60,
    this.navigationColor,
    this.notchedShape,
    this.elevation,
    NotchLocation? notchLocation,
    double? notchMargin,
    EdgeInsetsGeometry? itemPadding,
  })  : notchLocation = notchLocation ?? NotchLocation.none,
        notchMargin = notchMargin ?? 4.0,
        badger = badger ?? const JBadger(),
        itemPadding = itemPadding ?? const EdgeInsets.all(8),
        super(key: key);

  //构建页面底部导航条
  static Widget bottomNavigationBar({
    Key? key,
    //角标参数
    JBadger? badger,
    //基础参数
    required NavigationController<NavigationItem> controller,
    double navigationHeight = 60,
    Color? navigationColor,
    double? elevation,
    NotchLocation? notchLocation,
    double? notchMargin,
    NotchedShape? notchedShape,
    EdgeInsetsGeometry? itemPadding,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(navigationHeight),
      child: JBottomBar(
        key: key,
        controller: controller,
        navigationHeight: navigationHeight,
        navigationColor: navigationColor,
        elevation: elevation,
        notchLocation: notchLocation,
        notchMargin: notchMargin,
        notchedShape: notchedShape,
        itemPadding: itemPadding,
        badger: badger,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _JBottomBarState();
}

/*
* 底部导航组件-状态
* @author JTech JH
* @Time 2022/4/2 9:25
*/
class _JBottomBarState extends BaseState<JBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: widget.navigationColor ?? JUtil.getAccentColor(context),
      elevation: widget.elevation,
      shape: widget.notchedShape,
      notchMargin: widget.notchMargin,
      child: ValueListenableBuilder<int>(
        valueListenable: widget.controller,
        builder: (context, currentIndex, child) {
          var bottomBars = List<Widget>.generate(
            widget.controller.itemLength,
            (index) => _buildBottomBarItem(
                widget.controller.getItem(index), index == currentIndex, index),
          );
          if (widget.notchLocation != NotchLocation.none) {
            int notchIndex = 0;
            if (widget.notchLocation == NotchLocation.end) {
              notchIndex = widget.controller.itemLength;
            } else if (widget.notchLocation == NotchLocation.center) {
              notchIndex = widget.controller.itemLength ~/ 2;
            }
            bottomBars.insert(notchIndex, const Expanded(child: EmptyBox()));
          }
          return Row(children: bottomBars);
        },
      ),
    );
  }

  //构建底部导航子项
  _buildBottomBarItem(NavigationItem item, bool selected, int index) {
    return Expanded(
      child: ValueListenableBuilder<Map<int, String>>(
        valueListenable: widget.controller.navigationBadgeMap,
        builder: (_, value, child) {
          var badgeValue = value[index] ?? "";
          return InkWell(
            child: Container(
              height: widget.navigationHeight,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: JBadge(
                controller: JBadgeController(
                  initialValue: badgeValue,
                ),
                child: Padding(
                  padding: widget.itemPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (selected ? item.activeIcon : item.icon) ??
                          const EmptyBox(),
                      (selected ? item.activeTitle : item.title) ??
                          const EmptyBox(),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () => widget.controller.select(index),
          );
        },
      ),
    );
  }
}

/*
* notch所在位置
* @author JTech JH
* @Time 2022/4/2 9:38
*/
enum NotchLocation {
  start,
  end,
  center,
  none,
}
