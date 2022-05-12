import 'package:jtech_pomelo/model/option_item.dart';

/*
* 选择项子项
* @author JTech JH
* @Time 2022/4/6 16:10
*/
class SelectItem extends OptionItem {
  const SelectItem({
    required String? id,
    required String text,
    bool? enable,
  }) : super(
          text: text,
          id: id,
          enable: enable,
        );

  //相同字段
  const SelectItem.same({
    required String text,
    bool? enable,
  }) : super(
          text: text,
          id: text,
          enable: enable,
        );
}
