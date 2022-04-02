import 'package:jtech_pomelo/base/base_notifier.dart';

/*
* 导航角标控制器
* @author JTech JH
* @Time 2022/4/2 15:07
*/
abstract class NavigationBadgeController {
  //导航子项角标数据表
  final navigationBadgeMap = MapValueChangeNotifier<int, String>.empty();

  //添加角标数据
  void addBadge(int index, String value) =>
      navigationBadgeMap.putValue(index, value);

  //清除角标数据
  String? clearBadge(int index) => navigationBadgeMap.removeValue(index);

  //清除所有角标数据
  void clearAllBadges() => navigationBadgeMap.clear();
}
