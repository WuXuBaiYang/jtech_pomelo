import 'package:flutter/cupertino.dart';
import 'package:jtech_pomelo/model/menu_item.dart';

/*
* 选择器菜单项
* @author JTech JH
* @Time 2022/3/29 16:47
*/
class PickerMenuItem extends MenuItem {
  //选择类型
  final PickerType type;

  //允许选择的文件后缀(仅自定义模式生效)
  final List<String>? allowedExtensions;

  PickerMenuItem({
    required this.type,
    this.allowedExtensions,
    //基础参数
    required String text,
    bool enable = true,
    String? subText,
    Widget? icon,
  })  : assert(
            type == PickerType.custom &&
                null != allowedExtensions &&
                allowedExtensions.isNotEmpty,
            "当选择自定义附件类型时，allowedExtensions 参数不能为空"),
        super(
          text: text,
          enable: enable,
          subText: subText,
          icon: icon,
        );

  //图片选择
  PickerMenuItem.image({
    required String text,
    bool enable = true,
    String? subText,
    Widget? icon,
  }) : this(
          type: PickerType.image,
          text: text,
          enable: enable,
          subText: subText,
          icon: icon,
        );

  //图片拍摄
  PickerMenuItem.imageTake({
    required String text,
    bool enable = true,
    String? subText,
    Widget? icon,
  }) : this(
          type: PickerType.imageTake,
          text: text,
          enable: enable,
          subText: subText,
          icon: icon,
        );

  //视频选择
  PickerMenuItem.video({
    required String text,
    bool enable = true,
    String? subText,
    Widget? icon,
  }) : this(
          type: PickerType.video,
          text: text,
          enable: enable,
          subText: subText,
          icon: icon,
        );

  //视频录制
  PickerMenuItem.videoRecord({
    required String text,
    bool enable = true,
    String? subText,
    Widget? icon,
  }) : this(
          type: PickerType.videoRecord,
          text: text,
          enable: enable,
          subText: subText,
          icon: icon,
        );

  //视频录制
  PickerMenuItem.custom({
    required String text,
    required List<String> allowedExtensions,
    bool enable = true,
    String? subText,
    Widget? icon,
  }) : this(
          type: PickerType.custom,
          allowedExtensions: allowedExtensions,
          text: text,
          enable: enable,
          subText: subText,
          icon: icon,
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
