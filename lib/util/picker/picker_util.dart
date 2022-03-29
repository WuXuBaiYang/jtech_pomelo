import 'package:flutter/material.dart';
import 'package:jtech_pomelo/util/picker/menu_item.dart';
import 'package:jtech_pomelo/util/sheet_util.dart';

/*
* 附件选择工具方法
* @author JTech JH
* @Time 2022/3/29 17:00
*/
class PickerUtil {
  //默认选择方法
  static Future<String?> pick(
    BuildContext context, {
    required List<PickerMenuItem> menuItems,
    //当只有一条时，是否直接打开
    bool? directOpen,
    int? maxCount,
  }) async {
    //默认值
    directOpen ??= true;
    maxCount ??= 1;
    //当只有一条数据，并且可以直接打开，则不弹出菜单
    if (menuItems.length == 1 && directOpen) {
      return _doPick(menuItems.first, maxCount)?.id;
    }
    return JSheetUtil.showMenu(
      context,
      menuItems: menuItems,
      onItemTap: (_, i) => _doPick(menuItems[i], maxCount!),
    );
  }

  //执行选择操作
  static PickerMenuItem? _doPick(PickerMenuItem? item, int maxCount) {

  }
}
