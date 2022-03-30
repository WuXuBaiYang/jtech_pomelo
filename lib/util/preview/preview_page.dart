import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/manage/router.dart';
import 'package:jtech_pomelo/util/preview/options_item.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';

//自定义类型附件预览回调,返回值非空则替代默认预览方式
typedef PreviewItemBuilder = Widget? Function(
    PreviewOptionItem item, int index);

/*
* 附件预览页面
* @author JTech JH
* @Time 2022/3/30 13:59
*/
class PreviewPage extends BaseStatefulWidget {
  //附件预览构造器
  final PreviewItemBuilder? itemBuilder;

  //预览项集合
  final List<PreviewOptionItem> items;

  //初始化下标
  final int initialIndex;

  PreviewPage({
    Key? key,
    required this.items,
    this.initialIndex = 0,
    this.itemBuilder,
  })  : assert(items.isNotEmpty, "预览附件集合不可为空"),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PreviewPageState();
}

/*
* 附件预览页面-状态
* @author JTech JH
* @Time 2022/3/30 13:59
*/
class _PreviewPageState extends BaseState<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        child: ExtendedImageGesturePageView.builder(
          itemBuilder: (_, i) {
            var item = widget.items[i];
            var child = widget.itemBuilder?.call(item, i);
            return child ?? _previewMap[item.type]!(item);
          },
          itemCount: widget.items.length,
          controller: ExtendedPageController(
            initialPage: widget.initialIndex,
          ),
          scrollDirection: Axis.horizontal,
        ),
        onTap: () => jRouter.pop(),
      ),
    );
  }

  //附件预览实现表
  final Map<PreviewType, Widget Function(PreviewOptionItem item)> _previewMap =
      {
    PreviewType.image: (item) {
      return EmptyBox();
    },
    PreviewType.video: (item) {
      return EmptyBox();
    },
    PreviewType.other: (item) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.warning_rounded,
              color: Colors.white,
              size: 38,
            ),
            SizedBox(height: 8),
            Text(
              "该附件无法预览",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    },
  };
}
