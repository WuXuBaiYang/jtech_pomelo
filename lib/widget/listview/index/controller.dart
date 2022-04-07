import 'package:azlistview/azlistview.dart';
import 'package:jtech_pomelo/base/base_controller.dart';
import 'package:jtech_pomelo/widget/listview/index/model.dart';

/*
* 索引列表组件控制器
* @author JTech JH
* @Time 2022/4/7 14:32
*/
class IndexListViewController<V extends BaseIndexModel>
    extends BaseControllerList<V> {
  IndexListViewController({
    List<V>? dataList,
  }) : super([]) {
    //处理并设置数据
    setData(dataList ?? []);
  }

  //获取索引条数据集合
  List<String> get indexDataList => SuspensionUtil.getTagIndexList(value);

  //设置数据
  void setData(List<V> dataList) {
    SuspensionUtil.sortListBySuspensionTag(dataList);
    SuspensionUtil.setShowSuspensionStatus(dataList);
    setValue(dataList);
  }
}
