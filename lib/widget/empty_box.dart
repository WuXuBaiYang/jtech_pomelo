import 'package:flutter/cupertino.dart';

/*
* 占位或空容器用
* @author wuxubaiyang
* @Time 2021/7/8 下午4:50
*/
class EmptyBox extends SizedBox {
  const EmptyBox({Key? key}) : super(key: key, width: 0, height: 0);

  const EmptyBox.square({
    Key? key,
    double? size,
  }) : super(key: key, width: size, height: size);

  const EmptyBox.custom({
    Key? key,
    double? width,
    double? height,
  }) : super(key: key, width: width, height: height);
}
