import 'package:flutter/material.dart';
import 'package:jtech_pomelo/model/menu_item.dart';

//菜单项点击事件
typedef OnMenuItemTap = void Function(String? id, int i);

/*
* 底部弹出工具方法
* @author JTech JH
* @Time 2022/3/28 14:05
*/
class JSheetUtil {
  //展示带有标题的底部弹窗（appbar）
  static Future<T?> showAppBar<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    AppBar? appBar,
    Widget? bottomNavigationBar,
    //通用参数
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool? isScrollControlled,
    bool? isDismissible,
    bool? enableDrag,
  }) {
    return show<T>(
      context,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      builder: (_) => Scaffold(
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
        appBar: appBar,
        body: builder(_),
      ),
    );
  }

  //展示兼容输入框的底部弹窗
  static Future<T?> showInput<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    Duration? animDuration,
    VoidCallback? onAnimEnd,
    //通用参数
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool? isDismissible,
    bool? enableDrag,
  }) {
    //默认值
    animDuration ??= Duration.zero;
    return show<T>(
      context,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      builder: (_) => AnimatedPadding(
        padding: MediaQuery.of(_).viewInsets,
        duration: animDuration!,
        onEnd: onAnimEnd,
        child: builder(_),
      ),
    );
  }

  //展示底部菜单弹窗
  static Future<String?> showMenu(
    BuildContext context, {
    required List<MenuItem> menuItems,
    IndexedWidgetBuilder? separatorBuilder,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    OnMenuItemTap? onItemTap,
    EdgeInsetsGeometry? padding,
    //通用参数
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool? isScrollControlled,
    bool? isDismissible,
    bool? enableDrag,
  }) {
    //默认值
    separatorBuilder ??= (_, i) => const Divider();
    padding ??= const EdgeInsets.symmetric(vertical: 15);
    return show<String>(
      context,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (_) => ListView.separated(
        itemCount: menuItems.length,
        padding: padding,
        shrinkWrap: true,
        separatorBuilder: separatorBuilder!,
        itemBuilder: (_, i) {
          var item = menuItems[i];
          return ListTile(
            leading: item.icon,
            enabled: item.enable,
            title: Text(item.text, style: titleStyle),
            subtitle: null != item.subText
                ? Text(item.subText!, style: subTitleStyle)
                : null,
            onTap: () {
              onItemTap?.call(item.id, i);
              Navigator.pop(context, item.id);
            },
          );
        },
      ),
    );
  }

  //展示基础底部弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool? isScrollControlled,
    bool? isDismissible,
    bool? enableDrag,
  }) {
    isScrollControlled ??= false;
    isDismissible ??= true;
    enableDrag ??= true;
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: true,
    );
  }
}
