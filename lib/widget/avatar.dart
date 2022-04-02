import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/widget/image/clip.dart';
import 'package:jtech_pomelo/widget/image/image.dart';

/*
* 头像组件
* @author JTech JH
* @Time 2022/4/2 16:22
*/
class JAvatar extends BaseStatefulWidget {
  //头像资源文件
  final JFile file;

  //头像请求头部参数
  final Map<String, String>? headers;

  //头像点击事件
  final VoidCallback? onTap;

  //头像长点击事件
  final VoidCallback? onLongPress;

  //背景色
  final Color? color;

  //悬浮高度
  final double? elevation;

  //头像形状
  final AvatarShape shape;

  //圆角度数
  final double borderRadius;

  //头像尺寸
  final double size;

  //内间距
  final EdgeInsetsGeometry padding;

  //外间距
  final EdgeInsetsGeometry? margin;

  const JAvatar({
    Key? key,
    //基础参数
    required this.file,
    this.headers,
    this.onTap,
    this.onLongPress,
    this.color,
    this.elevation,
    this.margin,
    double? size,
    AvatarShape? shape,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  })  : size = size ?? 45,
        shape = shape ?? AvatarShape.circle,
        borderRadius = borderRadius ?? 8,
        padding = padding ?? EdgeInsets.zero,
        super(key: key);

  @override
  State<StatefulWidget> createState() => JAvatarState();
}

/*
* 头像组件-状态
* @author JTech JH
* @Time 2022/4/2 16:23
*/
class JAvatarState extends BaseState<JAvatar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      elevation: widget.elevation,
      shape: _getCardBorder(),
      margin: widget.margin,
      child: Padding(
        padding: widget.padding,
        child: JImage.jFile(
          widget.file,
          headers: widget.headers,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          clip: _getImageClip(),
        ),
      ),
    );
  }

  //获取卡片视图的形状
  ShapeBorder _getCardBorder() {
    switch (widget.shape) {
      case AvatarShape.circle: //圆形
        return const CircleBorder();
      case AvatarShape.roundRect: //圆角矩形
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        );
    }
  }

  //获取图片裁剪形状
  ImageClip _getImageClip() {
    switch (widget.shape) {
      case AvatarShape.circle: //圆形
        return const ImageClipOval();
      case AvatarShape.roundRect: //圆角矩形
        return ImageClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        );
    }
  }
}

/*
* 头像形状枚举
* @author JTech JH
* @Time 2022/4/2 16:32
*/
enum AvatarShape {
  circle,
  roundRect,
}
