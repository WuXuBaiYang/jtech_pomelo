import 'package:jtech_pomelo/base/base_model.dart';

/*
* 功能项
* @author JTech JH
* @Time 2022/3/28 16:38
*/
class OptionItem extends BaseModel {
  //id
  final dynamic id;

  //文本
  final String text;

  //是否可用
  final bool enable;

  OptionItem({
    required this.text,
    this.id,
    this.enable = true,
  });
}
