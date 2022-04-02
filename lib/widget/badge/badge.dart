import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/badge/badger.dart';
import 'package:jtech_pomelo/widget/badge/controller.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';

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

  //角标基础参数
  final JBadger badger;

  const JBadge({
    Key? key,
    required this.controller,
    required this.child,
    JBadger? badger,
  })  : badger = badger ?? const JBadger(),
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
      alignment: widget.badger.align,
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
            color: widget.badger.color,
            margin: widget.badger.margin,
            shape: widget.badger.shape,
            elevation: widget.badger.elevation,
            child: Container(
              padding: widget.badger.padding,
              constraints: widget.badger.constraints,
              child: widget.badger.badgeBuilder?.call(value) ??
                  Text(value, style: widget.badger.style),
            ),
          );
        }
        return const EmptyBox();
      },
    );
  }
}
