import 'package:jtech_pomelo/base/base_controller.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';

/*
* 附件表格列表控制器
* @author JTech JH
* @Time 2022/4/7 16:52
*/
class AccessoryGridViewController extends BaseControllerList<JFile> {
  AccessoryGridViewController({
    List<JFile>? dataList,
  }) : super(dataList ?? []);
}
