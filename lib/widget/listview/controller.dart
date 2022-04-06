import 'package:jtech_pomelo/base/base_controller.dart';

//列表数据过滤回调
typedef ListFilter<V> = bool Function(V item);

/*
* 列表控制器
* @author JTech JH
* @Time 2022/4/6 16:48
*/
class ListViewController<V> extends BaseControllerList<V> {
  ListViewController({
    List<V>? dataList,
  }) : super(dataList ?? []);

  //覆盖数据
  void setData(List<V> newData) {
    if (isFilterData) return;
    setValue(newData);
  }

  //添加数据，insertIndex=-1时放置在队列末尾
  void addData(
    List<V> newData, {
    int insertIndex = -1,
    bool clearData = false,
  }) {
    if (isFilterData) return;
    if (clearData) clear();
    if (insertIndex > 0 && insertIndex < length) {
      insertValue(insertIndex, newData);
    } else {
      addValue(newData);
    }
  }

  //原始数据列表
  List<V>? _originDateList;

  //判断是否正在过滤数据状态中
  bool get isFilterData => null != _originDateList;

  //数据过滤
  void filter(ListFilter filter) {
    _originDateList ??= value;
    List<V> tempList = [];
    for (V item in _originDateList!) {
      if (filter(item)) tempList.add(item);
    }
    setValue(tempList);
  }

  //清除过滤内容
  void clearFilter() {
    if (null == _originDateList) return;
    setValue(_originDateList!);
    _originDateList = null;
  }

  @override
  void dispose() {
    _originDateList?.clear();
    super.dispose();
  }
}
