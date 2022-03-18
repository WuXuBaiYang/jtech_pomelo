import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:math';

import './data_util.dart';

/*
* 通用工具方法
* @author JTech JH
* @Time 2022/3/17 14:26
*/
class JUtil {
  //生成id
  static String genID({int? seed}) {
    var time = DateTime.now().millisecondsSinceEpoch;
    return md5("${time}_${Random(seed ?? time).nextDouble()}");
  }

  //生成时间戳签名
  static String genDateSign() =>
      JDateUtil.formatDate(JDatePattern.dateSign, DateTime.now());

  //计算md5
  static String md5(String value) =>
      crypto.md5.convert(utf8.encode(value)).toString();

  //获取屏幕宽度
  static double getScreenWith(BuildContext context) =>
      MediaQuery.of(context).size.width;

  //获取屏幕高度
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  //获取状态栏高度
  static double getStatusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;
}

//判断当前是否为debug状态
bool get debugMode =>
    !const bool.fromEnvironment("dart.vm.product", defaultValue: false);

//将map转为query的url
String toQueryUrl(String url, Map<String, dynamic> params) {
  if (params.isNotEmpty) url += "?";
  for (var entry in params.entries) {
    url += "&${entry.key}=${entry.value}";
  }
  return url;
}

//地址路径拼接
String join(String part1,
        [String? part2,
        String? part3,
        String? part4,
        String? part5,
        String? part6,
        String? part7,
        String? part8]) =>
    path.join(part1, part2, part3, part4, part5, part6, part7, part8);

//地址路径拼接
String joinAll(Iterable<String> parts) => path.joinAll(parts);
