import 'package:flutter/cupertino.dart';
import 'package:jtech_pomelo/model/option_item.dart';

/*
* 菜单项
* @author JTech JH
* @Time 2022/3/29 16:20
*/
class MenuItem extends OptionItem {
  //副标题
  final String? subText;

  //图标
  final Widget? icon;

  MenuItem({
    required String text,
    dynamic id,
    bool enable = true,
    //基础参数
    this.subText,
    this.icon,
  }) : super(text: text, id: id, enable: enable);
}
