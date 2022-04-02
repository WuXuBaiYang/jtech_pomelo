import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/badge/badger.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_controller.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_item.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_pageview.dart';
import 'package:jtech_pomelo/widget/navigation/tab_layout.dart';

import 'navigation/bottom_bar.dart';

/*
* 页面组件
* @author JTech JH
* @Time 2022/4/1 9:58
*/
class JAppPage extends BaseStatelessWidget {
  //标题组件
  final PreferredSizeWidget? appBar;

  //判断是否展示标题栏
  final bool showAppbar;

  //页面内容元素
  final Widget body;

  //标题，左侧元素
  final Widget? leading;

  //标题栏左侧按钮类型
  final LeadingType leadingType;

  //标题文本
  final Widget? title;

  //标题动作元素集合
  final List<Widget> actions;

  //背景色
  final Color? backgroundColor;

  //底部导航栏组件
  final Widget? bottomNavigationBar;

  //fab按钮组件
  final Widget? floatingActionButton;

  //fab按钮位置
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  //fab按钮动画
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  //标题栏底部内容
  final PreferredSizeWidget? appBarBottom;

  const JAppPage({
    Key? key,
    required this.body,
    this.appBar,
    this.title,
    this.leading,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.floatingActionButtonAnimator,
    this.appBarBottom,
    bool? showAppbar,
    LeadingType? leadingType,
    List<Widget>? actions,
  })  : showAppbar = showAppbar ?? true,
        leadingType = leadingType ?? LeadingType.back,
        actions = actions ?? const [],
        super(key: key);

  //顶部导航组件
  JAppPage.tabLayout({
    Key? key,
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
    bool? canScroll,
    Duration? duration,
    //角标参数
    JBadger? badger,
    //基础参数
    PreferredSizeWidget? appBar,
    bool? showAppbar,
    Widget? leading,
    LeadingType? leadingType,
    Widget? title,
    List<Widget>? actions,
    Color? backgroundColor,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
  }) : this(
          key: key,
          appBar: appBar,
          showAppbar: showAppbar,
          appBarBottom: JTabLayout.appBarBottom(
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
            badger: badger,
          ),
          body: JNavigationPageView(
            controller: controller,
            canScroll: canScroll,
            duration: duration,
          ),
          leading: leading,
          leadingType: leadingType,
          title: title,
          actions: actions,
          backgroundColor: backgroundColor,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
        );

  //底部导航组件
  JAppPage.bottomBar({
    Key? key,
    required NavigationController<NavigationItem> controller,
    double navigationHeight = 60,
    Color? navigationColor,
    double? elevation,
    NotchLocation? notchLocation,
    double? notchMargin,
    NotchedShape? notchedShape,
    bool? canScroll,
    Duration? duration,
    //角标参数
    JBadger? badger,
    //基础参数
    PreferredSizeWidget? appBar,
    bool? showAppbar,
    PreferredSizeWidget? appBarBottom,
    Widget? leading,
    LeadingType? leadingType,
    Widget? title,
    List<Widget>? actions,
    Color? backgroundColor,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
  }) : this(
          key: key,
          appBar: appBar,
          showAppbar: showAppbar,
          appBarBottom: appBarBottom,
          body: JNavigationPageView(
            controller: controller,
            canScroll: canScroll,
            duration: duration,
          ),
          leading: leading,
          leadingType: leadingType,
          title: title,
          actions: actions,
          backgroundColor: backgroundColor,
          bottomNavigationBar: JBottomBar.bottomNavigationBar(
            controller: controller,
            navigationHeight: navigationHeight,
            navigationColor: navigationColor,
            elevation: elevation,
            notchLocation: notchLocation,
            notchMargin: notchMargin,
            notchedShape: notchedShape,
            badger: badger,
          ),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: body,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
    );
  }

  //构建标题栏
  PreferredSizeWidget? _buildAppBar() {
    if (!showAppbar) return null;
    if (null != appBar) return appBar;
    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
      bottom: appBarBottom,
    );
  }
}

/*
* 标题栏左侧按钮类型
* @author JTech JH
* @Time 2022/4/1 10:01
*/
enum LeadingType {
  none,
  back,
  close,
}
