import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/model/menu_item.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';

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
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
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
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
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
  static Future<T?> showMenu<T extends JMenuItem>(
    BuildContext context, {
    required List<T> menuItems,
    IndexedWidgetBuilder? separatorBuilder,
    bool? showDivider,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    ItemTap<T>? onItemTap,
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
    showDivider ??= true;
    separatorBuilder ??= (_, i) => const Divider();
    padding ??= const EdgeInsets.symmetric(vertical: 15);
    return show<T>(
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
        separatorBuilder: (c, i) {
          if (showDivider!) return separatorBuilder!(c, i);
          return const EmptyBox();
        },
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
              onItemTap?.call(item, i);
              Navigator.pop(context, item);
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
