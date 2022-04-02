import 'package:jtech_pomelo/base/base_controller.dart';

/*
* 角标控制器
* @author JTech JH
* @Time 2022/4/2 10:34
*/
class JBadgeController extends BaseController<String> {
  JBadgeController({
    String initialValue = "",
  }) : super(initialValue);

  //获取当前展示状态
  bool get showBadge => value.isNotEmpty;

  //清空当前角标内容
  void clear() => setValue("");
}
