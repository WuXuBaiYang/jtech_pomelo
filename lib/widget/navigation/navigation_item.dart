import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_model.dart';

/*
* 导航子项
* @author JTech JH
* @Time 2022/4/1 16:30
*/
class NavigationItem extends BaseModel {
  //内容视图
  final Widget page;

  //导航子项标题
  final Widget? title;

  //选中状态子项标题
  final Widget? activeTitle;

  //导航子项图片
  final Widget? image;

  //选中状态子项图片
  final Widget? activeImage;

  NavigationItem({
    required this.page,
    this.title,
    Widget? activeTitle,
    this.image,
    Widget? activeImage,
  })  : activeTitle = activeTitle ?? title,
        activeImage = activeImage ?? image;

  //文本子项
  NavigationItem.text({
    required String title,
    required this.page,
    double fontSize = 14,
    Color titleColor = Colors.white,
    String? activeTitle,
    double? activeFontSize,
    Color? activeTitleColor,
    this.image,
    Widget? activeImage,
  })  : activeImage = activeImage ?? image,
        title = Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: titleColor,
          ),
        ),
        activeTitle = Text(
          activeTitle ?? title,
          style: TextStyle(
            fontSize: activeFontSize ?? fontSize,
            color: activeTitleColor ?? titleColor,
          ),
        );
}
