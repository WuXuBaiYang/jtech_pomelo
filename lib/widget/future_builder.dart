import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';

/*
* 异步加载组件
* @author JTech JH
* @Time 2022/3/31 15:52
*/
class JFutureBuilder<V> extends BaseStatefulWidget {
  //异步加载构造器
  final AsyncWidgetBuilder<V> builder;

  //初始化数据
  final V? initialData;

  //异步加载方法
  final Future<V> Function() future;

  //重试组件
  final Widget? retryChild;

  //加载组件
  final Widget? loadingChild;

  //是否缓存标记
  final bool cached;

  //最小高度
  final double minHeight;

  //最大高度
  final double maxHeight;

  const JFutureBuilder({
    Key? key,
    bool? cached,
    double? minHeight,
    double? maxHeight,
    required this.future,
    required this.builder,
    this.initialData,
    this.retryChild,
    this.loadingChild,
  })  : cached = cached ?? true,
        minHeight = minHeight ?? 100,
        maxHeight = maxHeight ?? double.infinity,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JFutureBuilderState<V>();
}

/*
* 异步加载组件-状态
* @author JTech JH
* @Time 2022/3/9 12:28
*/
class _JFutureBuilderState<V> extends BaseState<JFutureBuilder<V>> {
  //缓存标记
  late bool refreshed = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<V>(
      future: _loadData(),
      initialData: widget.initialData,
      builder: (c, snap) {
        return Container(
          constraints: BoxConstraints(
            minHeight: widget.minHeight,
            maxHeight: widget.maxHeight,
          ),
          child: Builder(
            builder: (BuildContext context) {
              if (!refreshed) {
                if (snap.hasError) {
                  return widget.retryChild ??
                      Center(
                        child: OutlinedButton(
                          child: const Text("重试"),
                          onPressed: () => setState(() {
                            refreshed = true;
                          }),
                        ),
                      );
                }
                if (snap.hasData) {
                  return widget.builder(c, snap);
                }
              }
              return widget.loadingChild ??
                  const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  //缓存数据
  V? cachedData;

  //加载数据
  Future<V> _loadData() async {
    try {
      return widget.cached
          ? cachedData ??= await widget.future()
          : cachedData = await widget.future();
    } catch (e) {
      rethrow;
    } finally {
      refreshed = false;
    }
  }
}
