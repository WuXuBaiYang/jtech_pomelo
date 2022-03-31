import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/manage/router.dart';
import 'package:jtech_pomelo/pomelo.dart';
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
            if (null != child) return child;
            switch (item.type) {
              case PreviewType.image: //图片预览
                return _buildImagePreview(context, item);
              case PreviewType.video: //视频预览
                return _buildVideoPreview(context, item);
              case PreviewType.other: //其他预览
                return _buildOtherPreview(context, item);
            }
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

  //构建图片预览
  Widget _buildImagePreview(BuildContext context, PreviewOptionItem item) {
    return JImage.jFile(
      item.file,
      mode: ExtendedImageMode.gesture,
      gestureConfig: GestureConfig(
        cacheGesture: true,
        inPageView: true,
      ),
    );
  }

  //构建视频预览
  Widget _buildVideoPreview(BuildContext context, PreviewOptionItem item) {
    return EmptyBox();
  }

  //构建其他预览
  Widget _buildOtherPreview(BuildContext context, PreviewOptionItem item) {
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
  }
}
