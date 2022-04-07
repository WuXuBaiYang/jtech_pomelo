import 'package:jtech_pomelo/widget/listview/controller.dart';

/*
* 表格列表控制器
* @author JTech JH
* @Time 2022/4/6 16:52
*/
class GridViewController<V> extends ListViewController<V> {
  GridViewController({
    List<V>? dateList,
    bool? initialRefresh,
    int? initialPageIndex,
    int? pageSize,
  }) : super(
          dataList: dateList,
          initialRefresh: initialRefresh,
          initialPageIndex: initialPageIndex,
          pageSize: pageSize,
        );
}
