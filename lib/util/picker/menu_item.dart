import 'package:flutter/material.dart';
import 'package:jtech_pomelo/model/menu_item.dart';

/*
* 选择器菜单项
* @author JTech JH
* @Time 2022/3/29 16:47
*/
class PickerMenuItem extends JMenuItem {
  //选择类型
  final PickerType type;

  //允许选择的文件后缀(仅自定义模式生效)
  final List<String>? allowedExtensions;

  //是否使用前置摄像头
  final bool frontCamera;

  //最大图片高度(图片拍摄有效)
  final double? maxWidth;

  //最大图片宽度(图片拍摄有效)
  final double? maxHeight;

  //图片压缩比例(图片拍摄有效)
  final int? imageQuality;

  //最大可选择视频长度
  final Duration? maxDuration;

  PickerMenuItem({
    required this.type,
    this.allowedExtensions,
    this.imageQuality,
    this.maxDuration,
    this.maxWidth,
    this.maxHeight,
    bool? frontCamera,
    //基础参数
    required String text,
    String? id,
    bool? enable,
    String? subText,
    Widget? icon,
  })  : frontCamera = frontCamera ?? false,
        assert(
            type == PickerType.custom
                ? null != allowedExtensions && allowedExtensions.isNotEmpty
                : true,
            "当选择自定义附件类型时，allowedExtensions 参数不能为空"),
        super(
          text: text,
          id: id,
          enable: enable,
          subText: subText,
          icon: icon,
        );

  //图片选择
  PickerMenuItem.image({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
    //基础参数
    required String text,
    String? id,
    bool? enable,
    String? subText,
    Widget? icon,
  }) : this(
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          type: PickerType.image,
          text: text,
          id: id,
          enable: enable,
          subText: subText,
          icon: icon ?? const Icon(Icons.insert_photo_outlined),
        );

  //图片拍摄
  PickerMenuItem.imageTake({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
    bool? frontCamera,
    //基础参数
    required String text,
    String? id,
    bool? enable,
    String? subText,
    Widget? icon,
  }) : this(
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          frontCamera: frontCamera,
          type: PickerType.imageTake,
          text: text,
          id: id,
          enable: enable,
          subText: subText,
          icon: icon ?? const Icon(Icons.add_a_photo_outlined),
        );

  //视频选择
  PickerMenuItem.video({
    //基础参数
    required String text,
    String? id,
    bool? enable,
    String? subText,
    Widget? icon,
  }) : this(
          type: PickerType.video,
          text: text,
          id: id,
          enable: enable,
          subText: subText,
          icon: icon ?? const Icon(Icons.video_collection_outlined),
        );

  //视频录制
  PickerMenuItem.videoRecord({
    bool? frontCamera,
    Duration? maxDuration,
    //基础参数
    required String text,
    String? id,
    bool? enable,
    String? subText,
    Widget? icon,
  }) : this(
          frontCamera: frontCamera,
          maxDuration: maxDuration,
          type: PickerType.videoRecord,
          text: text,
          id: id,
          enable: enable,
          subText: subText,
          icon: icon ?? const Icon(Icons.video_call_outlined),
        );

  //视频录制
  PickerMenuItem.custom({
    required List<String> allowedExtensions,
    //基础参数
    required String text,
    String? id,
    bool? enable,
    String? subText,
    Widget? icon,
  }) : this(
          type: PickerType.custom,
          allowedExtensions: allowedExtensions,
          text: text,
          id: id,
          enable: enable,
          subText: subText,
          icon: icon ?? const Icon(Icons.file_open_outlined),
        );
}

/*
* 选择类型枚举
* @author JTech JH
* @Time 2022/3/29 16:50
*/
enum PickerType {
  //图片选择
  image,
  //图片拍照
  imageTake,
  //视频选择
  video,
  //视频录制
  videoRecord,
  //自定义类型
  custom,
}
