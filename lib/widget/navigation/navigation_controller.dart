import 'package:jtech_pomelo/base/base_controller.dart';
import 'package:jtech_pomelo/widget/navigation/navigation_item.dart';

/*
* 导航组件控制器
* @author JTech JH
* @Time 2022/4/1 16:34
*/
class NavigationController<T extends NavigationItem>
    extends BaseController<int> {
  //导航子项集合
  final List<T> items;

  NavigationController({
    required this.items,
    int initialIndex = 0,
  })  : assert(initialIndex >= 0 && initialIndex < items.length, "初始下标超出数据范围"),
        super(initialIndex);

  //获取数据长度
  int get itemLength => items.length;

  //获取数据子项
  T getItem(int index) => items[index];

  //选中一个下标
  void select(int index) {
    if (index < 0 || index >= itemLength) index = 0;
    setValue(index);
  }

  @override
  void dispose() {
    //销毁数据
    items.clear();
    super.dispose();
  }
}
