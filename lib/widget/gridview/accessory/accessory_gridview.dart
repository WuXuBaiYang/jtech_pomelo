import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/util/match_util.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/util/picker/menu_item.dart';
import 'package:jtech_pomelo/util/picker/picker_util.dart';
import 'package:jtech_pomelo/util/preview/options_item.dart';
import 'package:jtech_pomelo/util/preview/preview_util.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/gridview/accessory/controller.dart';
import 'package:jtech_pomelo/widget/image/clip.dart';
import 'package:jtech_pomelo/widget/image/image.dart';

//附件预览回调
typedef AccessoryPreview = void Function(List<JFile> items, int index);

/*
* 附件表格列表组件
* @author JTech JH
* @Time 2022/4/7 16:53
*/
class JAccessoryGridView extends BaseStatefulWidget {
  //附件表格控制器
  final AccessoryGridViewController? controller;

  //最大附件选择数
  final int maxCount;

  //列表项构造器
  final ItemBuilder<JFile>? itemBuilder;

  //是否可滚动
  final bool canScroll;

  //内间距
  final EdgeInsetsGeometry padding;

  //子项点击事件
  final ItemTap<JFile>? itemTap;

  //子项长点击事件
  final ItemTap<JFile>? itemLongPress;

  //副方向上的最大元素数量
  final int crossAxisCount;

  //主方向元素间距
  final double mainAxisSpacing;

  //副方向元素间距
  final double crossAxisSpacing;

  //添加按钮
  final Widget? addButton;

  //删除按钮
  final Widget? deleteButton;

  //删除按钮位置
  final AlignmentGeometry deleteButtonAlign;

  //附件选择项
  final List<PickerMenuItem> pickerMenuItems;

  //附件项内间距
  final BorderRadius itemBorderRadius;

  //编辑操作是否可用
  final bool modify;

  //附件项内间距
  final EdgeInsetsGeometry itemPadding;

  //附件项占位图表
  final Map<RegExp, Widget> itemPlaceholderMap;

  //附件预览回调
  final AccessoryPreview? accessoryPreview;

  const JAccessoryGridView({
    Key? key,
    required this.pickerMenuItems,
    this.controller,
    this.itemTap,
    this.itemLongPress,
    this.addButton,
    this.deleteButton,
    this.itemBuilder,
    this.accessoryPreview,
    int? maxCount,
    int? crossAxisCount,
    bool? canScroll,
    EdgeInsetsGeometry? padding,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    AlignmentGeometry? deleteButtonAlign,
    bool? modify,
    EdgeInsetsGeometry? itemPadding,
    Map<RegExp, Widget>? itemPlaceholderMap,
    BorderRadius? itemBorderRadius,
  })  : maxCount = maxCount ?? 9,
        crossAxisCount = crossAxisCount ?? 4,
        canScroll = canScroll ?? true,
        padding = padding ?? const EdgeInsets.all(8),
        mainAxisSpacing = mainAxisSpacing ?? 0.0,
        crossAxisSpacing = crossAxisSpacing ?? 0.0,
        deleteButtonAlign = deleteButtonAlign ?? Alignment.topRight,
        modify = modify ?? true,
        itemPadding = itemPadding ?? const EdgeInsets.all(8),
        itemPlaceholderMap = itemPlaceholderMap ?? const {},
        itemBorderRadius =
            itemBorderRadius ?? const BorderRadius.all(Radius.circular(8)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JAccessGridViewState();
}

/*
* 附件表格列表组件-状态
* @author JTech JH
* @Time 2022/4/7 16:53
*/
class _JAccessGridViewState extends BaseState<JAccessoryGridView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<JFile>>(
      valueListenable: controller,
      builder: (_, dataList, child) {
        return SingleChildScrollView(
          physics: scrollPhysics,
          padding: widget.padding,
          child: StaggeredGrid.count(
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
            crossAxisCount: widget.crossAxisCount,
            children: List.generate(dataLength, (index) {
              return StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Builder(builder: (_) {
                  if (isAddButton(index)) {
                    return _buildGridAdd(context, index);
                  }
                  return _buildGridItem(context, dataList[index], index);
                }),
              );
            }),
          ),
        );
      },
    );
  }

  //构建列表子项
  Widget _buildGridItem(BuildContext context, JFile item, int index) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: widget.itemPadding,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: widget.itemBorderRadius,
              ),
              child: InkWell(
                borderRadius: widget.itemBorderRadius,
                child: widget.itemBuilder?.call(context, item, index) ??
                    _buildGridItemDef(context, item, index),
                onTap: () {
                  widget.itemTap?.call(item, index);
                  _doFilePreview(item, index);
                },
                onLongPress: null != widget.itemLongPress
                    ? () => widget.itemLongPress!(item, index)
                    : null,
              ),
            ),
          ),
        ),
        _buildGridItemDelete(item),
      ],
    );
  }

  //构建附件项默认样式
  Widget _buildGridItemDef(BuildContext context, JFile item, int index) {
    //优先匹配用户定义的对照表
    if (widget.itemPlaceholderMap.isNotEmpty) {
      var patternStr = "${item.uri}${item.suffixes}";
      for (var pattern in widget.itemPlaceholderMap.keys) {
        if (JMatchUtil.hasMatch(pattern, string: patternStr)) {
          return widget.itemPlaceholderMap[item] ?? const EmptyBox();
        }
      }
    }
    //匹配本地预设的样式
    if (item.isImageType) {
      return JImage.jFile(
        item,
        fit: BoxFit.cover,
        clip: ImageClipRRect(borderRadius: widget.itemBorderRadius),
        placeholderBuilder: (_) =>
            Icon(Icons.image_outlined, color: Colors.grey[200]),
      );
    }
    //配置其他类型文件的预设样式
    return Center(
      child: Icon(
        _accessoryIconMap[item.suffixes] ?? FontAwesomeIcons.exclamation,
        size: 55,
        color: Colors.black26,
      ),
    );
  }

  //执行附件预览操作
  void _doFilePreview(JFile item, int index) {
    var values = controller.value;
    if (null != widget.accessoryPreview) {
      return widget.accessoryPreview!(values, index);
    }
    JPreviewUtil.preview(
      items: values.map<PreviewOptionItem>((e) {
        var type = PreviewType.other;
        if (e.isImageType) {
          type = PreviewType.image;
        } else if (e.isVideoType) {
          type = PreviewType.video;
        }
        return PreviewOptionItem(type: type, file: e);
      }).toList(),
      initialIndex: index,
    );
  }

  //构建附件项删除操作按钮
  Widget _buildGridItemDelete(JFile item) {
    if (!widget.modify) return const EmptyBox();
    var child = widget.deleteButton ?? _buildGridItemDefDelete(item);
    return Align(alignment: widget.deleteButtonAlign, child: child);
  }

  //构建附件项默认删除按钮
  Widget _buildGridItemDefDelete(JFile item) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: const CircleBorder(),
      child: IconButton(
        splashRadius: 12,
        padding: const EdgeInsets.all(4),
        iconSize: 16,
        color: Colors.black26,
        icon: const Icon(Icons.close),
        constraints: const BoxConstraints(minHeight: 20, minWidth: 20),
        onPressed: () => controller.removeValue(item),
      ),
    );
  }

  //构建附件添加按钮
  Widget _buildGridAdd(BuildContext context, int index) {
    var child = widget.addButton ?? _buildGridDefAdd();
    return Padding(
      padding: widget.itemPadding,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: widget.itemBorderRadius,
        ),
        child: InkWell(
          borderRadius: widget.itemBorderRadius,
          child: child,
          onTap: () async {
            var result = await JPickerUtil.pick(
              context,
              menuItems: widget.pickerMenuItems,
              maxCount: widget.maxCount,
            );
            controller.addValue(result.files);
          },
        ),
      ),
    );
  }

  //构建附件默认添加按钮
  Widget _buildGridDefAdd() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.itemBorderRadius,
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: const Icon(
        Icons.add_rounded,
        size: 55,
        color: Colors.black26,
      ),
    );
  }

  //判断是否为添加按钮
  bool isAddButton(int index) =>
      widget.modify && !hasMaxCount && index >= dataLength - 1;

  //获取数据长度
  int get dataLength =>
      controller.length + (!widget.modify || hasMaxCount ? 0 : 1);

  //判断是否已达到最大数据量
  bool get hasMaxCount => controller.length >= widget.maxCount;

  //滚动控制
  ScrollPhysics? get scrollPhysics =>
      widget.canScroll ? null : const NeverScrollableScrollPhysics();

  //缓存控制器对象
  AccessoryGridViewController? _controller;

  //获取控制器对象
  AccessoryGridViewController get controller =>
      widget.controller ?? (_controller ??= AccessoryGridViewController());

  @override
  void dispose() {
    //销毁控制器
    controller.dispose();
    super.dispose();
  }
}

//预设附件项类型占位图
final Map<String, IconData> _accessoryIconMap = {
  //压缩包类型
  ".7z": FontAwesomeIcons.fileZipper,
  ".rar": FontAwesomeIcons.fileZipper,
  ".tar": FontAwesomeIcons.fileZipper,
  ".zip": FontAwesomeIcons.fileZipper,
  //视频类型
  ".avi": FontAwesomeIcons.fileVideo,
  ".mp4": FontAwesomeIcons.fileVideo,
  ".mp5": FontAwesomeIcons.fileVideo,
  ".mpge": FontAwesomeIcons.fileVideo,
  //音频类型
  ".mp3": FontAwesomeIcons.fileAudio,
  ".aac": FontAwesomeIcons.fileAudio,
  //未识别图片类型
  ".bmp": FontAwesomeIcons.fileImage,
  ".svg": FontAwesomeIcons.fileImage,
  //文档类型
  ".docx": FontAwesomeIcons.fileWord,
  ".doc": FontAwesomeIcons.fileWord,
  ".pdf": FontAwesomeIcons.filePdf,
  ".ppt": FontAwesomeIcons.filePowerpoint,
  ".pptx": FontAwesomeIcons.filePowerpoint,
  ".text": FontAwesomeIcons.fileLines,
  ".txt": FontAwesomeIcons.fileLines,
  ".xlsx": FontAwesomeIcons.fileExcel,
  "unknown": FontAwesomeIcons.exclamation,
};
