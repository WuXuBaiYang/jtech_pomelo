import 'package:flutter/cupertino.dart';

/*
* 控制器基类
* @author JTech JH
* @Time 2022/3/30 17:32
*/
abstract class BaseController {
  const BaseController();

  //添加监听器
  @mustCallSuper
  void addListener(VoidCallback listener) {}

  //销毁控制器
  @mustCallSuper
  void dispose() {}
}
