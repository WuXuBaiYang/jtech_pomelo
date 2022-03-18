import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*
* 消息提示工具方法
* @author JTech JH
* @Time 2022/3/18 13:57
*/
class JToastUtil {
  //展示短时效提示
  //展示toast
  static Future<bool?> showShort(
    String message, {
    bool? centerToast,
    int? timeInSecForIosWeb,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
  }) =>
      show(
        message,
        shortToast: true,
        centerToast: centerToast,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
      );

  //展示长时效提示
  //展示toast
  static Future<bool?> showLong(
    String message, {
    bool? centerToast,
    int? timeInSecForIosWeb,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
  }) =>
      show(
        message,
        shortToast: false,
        centerToast: centerToast,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
      );

  //展示toast
  static Future<bool?> show(
    String message, {
    bool? shortToast,
    bool? centerToast,
    int? timeInSecForIosWeb = 1,
    Color? backgroundColor = Colors.black54,
    Color? textColor = Colors.white,
    double? fontSize = 16,
  }) {
    shortToast ??= true;
    centerToast ??= false;
    return Fluttertoast.showToast(
      msg: message,
      gravity: centerToast ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      toastLength: shortToast ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
      backgroundColor: backgroundColor ?? Colors.black54,
      textColor: textColor ?? Colors.white,
      fontSize: fontSize ?? 16,
    );
  }
}
