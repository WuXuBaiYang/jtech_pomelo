import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';

/*
* 空数据容器
* @author JTech JH
* @Time 2022/4/6 15:26
*/
class EmptyDataBox extends BaseStatelessWidget {
  //判断是否为空
  final bool isEmpty;

  //承接容器
  final Widget child;

  //提示文本
  final String hint;

  const EmptyDataBox({
    Key? key,
    required this.isEmpty,
    required this.child,
    this.hint = "空数据",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: isEmpty,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 90,
                  color: Colors.grey[300],
                ),
                Text(
                  hint,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
