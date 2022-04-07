import 'package:jtech_pomelo/base/base_controller.dart';
import 'package:jtech_pomelo/base/base_notifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//列表数据过滤回调
typedef ListFilter<V> = bool Function(V item);

/*
* 列表控制器
* @author JTech JH
* @Time 2022/4/6 16:48
*/
class ListViewController<V> extends BaseControllerList<V> {
  //下拉刷新控制器
  final RefreshController refreshController;

  //分页-默认初始页面
  final int initialPageIndex;

  //分页-单页数据量
  final int pageSize;

  //刷新状态
  final ValueChangeNotifier<RefreshState> refreshState;

  //分页-页码下标
  final ValueChangeNotifier<int> _pageIndex;

  ListViewController({
    List<V>? dataList,
    bool? initialRefresh,
    int? initialPageIndex,
    int? pageSize,
  })  : initialPageIndex = initialPageIndex ?? 1,
        pageSize = pageSize ?? 15,
        refreshState = ValueChangeNotifier(RefreshState.none),
        refreshController = RefreshController(
          initialRefresh: initialRefresh ?? false,
        ),
        _pageIndex = ValueChangeNotifier(initialPageIndex ?? 1),
        super(dataList ?? []) {
    //监听刷新状态变化
    refreshState.addListener(() {
      switch (refreshState.value) {
        case RefreshState.refreshCompleted:
          return refreshController.refreshCompleted(resetFooterState: true);
        case RefreshState.refreshFailed:
          return refreshController.refreshFailed();
        case RefreshState.loadComplete:
          return refreshController.loadComplete();
        case RefreshState.loadFailed:
          return refreshController.loadFailed();
        case RefreshState.loadNoData:
          return refreshController.loadNoData();
        case RefreshState.none:
          return;
      }
    });
  }

  //获取当前页码下标
  int get pageIndex => _pageIndex.value;

  //页码增加
  void rollPageIndex() => _pageIndex.setValue(_pageIndex.value + 1);

  //初始化页码
  void resetPageIndex() => _pageIndex.setValue(initialPageIndex);

  //根据刷新状态获取请求页码
  int getRequestPageIndex(bool loadMore) =>
      loadMore ? _pageIndex.value + 1 : initialPageIndex;

  //完成请求操作
  void requestCompleted(List<V> dataList, {bool loadMore = false}) {
    if (dataList.isEmpty || dataList.length < pageSize) {
      if (!loadMore) refreshCompleted(dataList);
      return loadNoMoreData();
    }
    loadMore ? loadCompleted(dataList) : refreshCompleted(dataList);
  }

  //完成刷新操作
  void refreshCompleted(List<V> dataList) {
    refreshState.setValue(RefreshState.refreshCompleted);
    setData(dataList);
    resetPageIndex();
  }

  //完成加载操作
  void loadCompleted(List<V> dataList) {
    refreshState.setValue(RefreshState.loadComplete);
    addData(dataList);
    rollPageIndex();
  }

  //加载无更多数据状态
  void loadNoMoreData() => refreshState.setValue(RefreshState.loadNoData);

  //失败
  void requestFail(bool loadMore) => loadMore ? loadFail() : refreshFail();

  //刷新失败
  void refreshFail() => refreshState.setValue(RefreshState.refreshFailed);

  //加载失败
  void loadFail() => refreshState.setValue(RefreshState.loadFailed);

  //重置刷新状态
  void resetRefreshState() => refreshState.setValue(RefreshState.none);

  //覆盖数据
  void setData(List<V> dataList) {
    if (isFilterData) return;
    setValue(dataList);
  }

  //添加数据，insertIndex=-1时放置在队列末尾
  void addData(
    List<V> dataList, {
    int insertIndex = -1,
  }) {
    if (isFilterData) return;
    if (insertIndex > 0 && insertIndex < length) {
      insertValue(insertIndex, dataList);
    } else {
      addValue(dataList);
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
    if (null != _originDateList) {
      setValue(_originDateList!);
    }
    _originDateList = null;
  }

  @override
  void dispose() {
    refreshController.dispose();
    _originDateList?.clear();
    super.dispose();
  }
}

/*
* 刷新状态枚举
* @author JTech JH
* @Time 2022/4/7 13:30
*/
enum RefreshState {
  refreshCompleted,
  refreshFailed,
  loadComplete,
  loadFailed,
  loadNoData,
  none,
}
