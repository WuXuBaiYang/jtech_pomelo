import 'package:flutter/material.dart';
import 'package:jtech_pomelo/manage/event.dart';

/*
* 全局样式控制事件
* @author JTech JH
* @Time 2022/4/1 15:14
*/
class ThemeEvent extends EventModel {
  //全局样式
  final ThemeData themeData;

  ThemeEvent({required this.themeData});
}
