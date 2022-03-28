import 'package:flutter/cupertino.dart';
import 'package:jtech_pomelo/base/base_model.dart';

/*
* 菜单子项对象
* @author JTech JH
* @Time 2022/3/28 16:38
*/
class MenuItem extends BaseModel {
  //菜单id
  final String? id;

  //标题
  final String title;

  //副标题
  final String? subTitle;

  //头部图标
  final Widget? icon;

  //是否可用
  final bool enable;

  MenuItem({
    required this.title,
    this.id,
    this.subTitle,
    this.icon,
    bool? enable,
  }) : enable = enable ?? true;
}
