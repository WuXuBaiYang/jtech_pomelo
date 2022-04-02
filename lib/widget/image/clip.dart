import 'package:flutter/widgets.dart';

/*
* 图片裁剪方法基类
* @author JTech JH
* @Time 2022/3/31 14:27
*/
abstract class ImageClip {
  const ImageClip();

  //裁剪方法
  Widget clip(BuildContext context, Widget child);
}

/*
* 圆形图片裁剪
* @author JTech JH
* @Time 2022/3/31 14:27
*/
class ImageClipOval extends ImageClip {
  //自定义裁剪方法
  final CustomClipper<Rect>? clipper;

  //裁剪方法
  final Clip clipBehavior;

  const ImageClipOval({
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget clip(BuildContext context, Widget child) {
    return ClipOval(
      child: child,
      clipper: clipper,
      clipBehavior: clipBehavior,
    );
  }
}

/*
* R角图片裁剪
* @author JTech JH
* @Time 2022/3/31 14:28
*/
class ImageClipRRect extends ImageClip {
  //圆角控制
  final BorderRadius borderRadius;

  //自定义裁剪方法
  final CustomClipper<RRect>? clipper;

  //裁剪方法
  final Clip clipBehavior;

  const ImageClipRRect({
    required this.borderRadius,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget clip(BuildContext context, Widget child) {
    return ClipRRect(
      child: child,
      borderRadius: borderRadius,
      clipper: clipper,
      clipBehavior: clipBehavior,
    );
  }
}
