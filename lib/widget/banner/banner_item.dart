import 'package:flutter/cupertino.dart';
import 'package:jtech_pomelo/model/option_item.dart';

/*
* 轮播组件子项
* @author JTech JH
* @Time 2022/4/6 10:02
*/
class BannerItem extends OptionItem {
  //轮播子项视图
  Widget child;

  BannerItem({
    required this.child,
    String? text,
    String? id,
    bool? enable,
  }) : super(
          text: text ?? "",
          id: id,
          enable: enable,
        );
}
