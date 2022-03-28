import 'dart:async';
import 'package:flutter/material.dart';

import '../widget/empty_box.dart';

//加载弹窗加载回调
typedef OnLoading<T> = Future<T> Function();

/*
* 弹窗工具方法
* @author JTech JH
* @Time 2022/3/18 16:03
*/
class JDialogUtil {
  //缓存加载弹窗对象
  static Future<void>? _loadingDialog;

  //展示等待弹窗，包含future
  static Future<T?> showInLoading<T>(
    BuildContext context, {
    required OnLoading<T> onLoading,
    //通用参数
    bool? barrierDismissible,
    Color? barrierColor,
    bool? useSafeArea,
  }) async {
    showLoading(
      context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
    );
    var result = await onLoading();
    await hideLoading(context);
    return result;
  }

  //展示等待弹窗
  static Future<void> showLoading(
    BuildContext context, {
    //通用参数
    bool? barrierDismissible,
    Color? barrierColor,
    bool? useSafeArea,
  }) async {
    await hideLoading(context);
    return _loadingDialog ??= show<void>(
      context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    )..whenComplete(() => _loadingDialog = null);
  }

  //隐藏加载弹窗
  static Future<void> hideLoading(BuildContext context) async {
    if (null == _loadingDialog) return;
    return Navigator.pop(context);
  }

  //展示消息弹窗
  static Future<T?> showAlert<T>(
    BuildContext context, {
    required Widget content,
    List<Widget> actions = const [],
    Widget? title,
    bool? centerTitle,
    double? maxRatio,
    EdgeInsetsGeometry? padding,
    //通用参数
    bool? barrierDismissible,
    Color? barrierColor,
    bool? useSafeArea,
  }) {
    //默认值
    maxRatio ??= 0.8;
    padding ??= const EdgeInsets.symmetric(vertical: 8, horizontal: 15);
    var size = MediaQuery.of(context).size;
    var maxHeight = size.height * maxRatio;
    var maxWidth = size.width * maxRatio;
    return show<T>(
      context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      builder: (_) => Center(
        child: Card(
          child: Container(
            padding: padding,
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: maxWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  child: title ?? const EmptyBox(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                DefaultTextStyle(
                  child: content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //展示默认弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool? barrierDismissible,
    Color? barrierColor,
    bool? useSafeArea,
  }) {
    //默认值
    barrierDismissible ??= true;
    barrierColor ??= Colors.black54;
    useSafeArea ??= true;
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
    );
  }
}
