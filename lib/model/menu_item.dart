import 'package:flutter/cupertino.dart';
import 'package:jtech_pomelo/model/option_item.dart';

/*
* 菜单项
* @author JTech JH
* @Time 2022/3/29 16:20
*/
class MenuItem<V> extends OptionItem {
  //副标题
  final String? subText;

  //图标
  final Widget? icon;

  //携带值
  final V? value;

  MenuItem({
    this.subText,
    this.icon,
    this.value,
    //基础参数
    required String text,
    String? id,
    bool? enable,
  }) : super(
          text: text,
          id: id,
          enable: enable,
        );
}
