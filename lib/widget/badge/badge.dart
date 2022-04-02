import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/badge/controller.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';

//构建角标自定义内容
typedef BadgeBuilder = Widget Function(String value);

/*
* 角标组件
* @author JTech JH
* @Time 2022/4/2 10:37
*/
class JBadge extends BaseStatefulWidget {
  //角标控制器
  final JBadgeController controller;

  //角标依赖元素
  final Widget child;

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

  const JBadge({
    Key? key,
    required this.controller,
    required this.child,
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
            padding ?? const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JBadgeState();
}

/*
* 角标组件-状态
* @author JTech JH
* @Time 2022/4/2 10:37
*/
class _JBadgeState extends BaseState<JBadge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.align,
      children: [
        widget.child,
        _buildBadge(context),
      ],
    );
  }

  //构建角标
  Widget _buildBadge(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.controller,
      builder: (_, value, child) {
        if (widget.controller.showBadge) {
          return Card(
            color: widget.color,
            margin: widget.margin,
            shape: widget.shape,
            elevation: widget.elevation,
            child: Container(
              padding: widget.padding,
              constraints: widget.constraints,
              child: widget.badgeBuilder?.call(value) ??
                  Text(value, style: widget.style),
            ),
          );
        }
        return const EmptyBox();
      },
    );
  }
}
