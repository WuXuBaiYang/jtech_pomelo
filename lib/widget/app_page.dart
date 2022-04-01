import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';

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
    bool? showAppbar,
    LeadingType? leadingType,
    List<Widget>? actions,
  })  : showAppbar = showAppbar ?? true,
        leadingType = leadingType ?? LeadingType.back,
        actions = actions ?? const [],
        super(key: key);

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
