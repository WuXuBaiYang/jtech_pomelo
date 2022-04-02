import 'package:flutter/material.dart';

//构建角标自定义内容
typedef BadgeBuilder = Widget Function(String value);

/*
* 角标组件参数管理
* @author JTech JH
* @Time 2022/4/2 14:42
*/
class JBadger {
  //角标位置
  final AlignmentGeometry align;

  //角标展示文本样式
  final TextStyle style;

  //角标颜色
  final Color color;

  //外间距
  final EdgeInsetsGeometry margin;

  //内间距
  final EdgeInsetsGeometry padding;

  //角标容器
  final BoxConstraints constraints;

  //角标形状
  final ShapeBorder shape;

  //角标悬浮高度
  final double? elevation;

  //角标展示内容替换
  final BadgeBuilder? badgeBuilder;

  const JBadger({
    this.elevation,
    this.badgeBuilder,
    AlignmentGeometry? align,
    TextStyle? style,
    Color? color,
    BoxConstraints? constraints,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  })  : align = align ?? Alignment.topRight,
        style = style ?? const TextStyle(color: Colors.white, fontSize: 10),
        color = color ?? Colors.red,
        shape = shape ??
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100))),
        constraints =
            constraints ?? const BoxConstraints(minWidth: 8, minHeight: 8),
        margin = margin ?? EdgeInsets.zero,
        padding =
            padding ?? const EdgeInsets.symmetric(vertical: 2, horizontal: 8);
}
