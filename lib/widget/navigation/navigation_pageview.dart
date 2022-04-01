import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_controller.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_item.dart';

/*
* 导航页面组件
* @author JTech JH
* @Time 2022/4/1 17:04
*/
class JNavigationPageView extends BaseStatefulWidget {
  //导航控制器
  final NavigationController<NavigationItem> controller;

  //判断是否可滑动切换页面
  final bool canScroll;

  //页面切换动画时间
  final Duration duration;

  const JNavigationPageView({
    Key? key,
    required this.controller,
    bool? canScroll,
    Duration? duration,
  })  : canScroll = canScroll ?? true,
        duration = duration ?? const Duration(milliseconds: 200),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JNavigationPageViewState();
}

/*
* 导航页面组件-状态
* @author JTech JH
* @Time 2022/4/1 17:06
*/
class _JNavigationPageViewState extends BaseState<JNavigationPageView> {
  //页面切换控制器
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    //跳转到初始化页面
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      pageController.jumpToPage(widget.controller.value);
    });
    //监听页面变化
    widget.controller.addListener(() {
      var currentIndex = widget.controller.value;
      if (currentIndex != pageController.page?.round()) {
        pageController.animateToPage(
          currentIndex,
          duration: widget.duration,
          curve: Curves.linearToEaseOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: widget.canScroll ? null : const NeverScrollableScrollPhysics(),
      children: List.generate(
        widget.controller.itemLength,
        (index) => widget.controller.getItem(index).page,
      ),
      onPageChanged: (index) => widget.controller.select(index),
    );
  }

  @override
  void dispose() {
    //销毁控制器
    pageController.dispose();
    super.dispose();
  }
}
