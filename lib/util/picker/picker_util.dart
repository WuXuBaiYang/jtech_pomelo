import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/util/picker/menu_item.dart';
import 'package:jtech_pomelo/util/sheet_util.dart';

/*
* 附件选择工具方法
* @author JTech JH
* @Time 2022/3/29 17:00
*/
class PickerUtil {
  //选择图片附件
  static Future<JPickerResult> pickImage(
    BuildContext context, {
    //当只有一条时，是否直接打开
    bool? directOpen,
    int? maxCount,
    bool? imageTake,
  }) {
    //默认值
    directOpen ??= true;
    maxCount ??= 1;
    imageTake ??= true;
    var items = <PickerMenuItem>[
      PickerMenuItem.image(text: "选择图片"),
    ];
    if (imageTake) {
      items.add(PickerMenuItem.imageTake(text: "拍摄照片"));
    }
    return pick(
      context,
      menuItems: items,
      directOpen: directOpen,
      maxCount: maxCount,
    );
  }

  //选择视频
  static Future<JPickerResult> pickVideo(
    BuildContext context, {
    //当只有一条时，是否直接打开
    bool? directOpen,
    int? maxCount,
    bool? videoRecord,
  }) {
    directOpen ??= true;
    maxCount ??= 1;
    videoRecord ??= true;
    var items = <PickerMenuItem>[
      PickerMenuItem.video(text: "选择视频"),
    ];
    if (videoRecord) {
      items.add(PickerMenuItem.imageTake(text: "录制视频"));
    }
    return pick(
      context,
      menuItems: items,
      directOpen: directOpen,
      maxCount: maxCount,
    );
  }

  //选择自定义类型附件
  static Future<JPickerResult> pickCustom(
    BuildContext context, {
    required String itemText,
    required List<String> allowedExtensions,
    //当只有一条时，是否直接打开
    bool? directOpen,
    int? maxCount,
  }) {
    directOpen ??= true;
    maxCount ??= 1;
    var items = <PickerMenuItem>[
      PickerMenuItem.custom(
        text: itemText,
        allowedExtensions: allowedExtensions,
      ),
    ];
    return pick(
      context,
      menuItems: items,
      directOpen: directOpen,
      maxCount: maxCount,
    );
  }

  //默认选择方法
  static Future<JPickerResult> pick(
    BuildContext context, {
    required List<PickerMenuItem> menuItems,
    //当只有一条时，是否直接打开
    bool? directOpen,
    int? maxCount,
  }) {
    //默认值
    directOpen ??= true;
    maxCount ??= 1;
    //当只有一条数据，并且可以直接打开，则不弹出菜单
    if (menuItems.length == 1 && directOpen) {
      return _doPick(menuItems.first, maxCount);
    }
    return JSheetUtil.showMenu(
      context,
      showDivider: false,
      menuItems: menuItems,
    ).then<JPickerResult>((item) {
      return _doPick(item, maxCount!);
    });
  }

  //执行选择操作
  static Future<JPickerResult> _doPick(
      PickerMenuItem? item, int maxCount) async {
    List<JFile> files = [];
    if (null != item && maxCount > 0) {
      dynamic result = await _pickFile(item, maxCount > 1);
      if (result is List<XFile>) {
        for (var it in result) {
          files.add(await JFile.fromPath(it.path));
        }
      } else if (result is XFile) {
        files.add(await JFile.fromPath(result.path));
      } else if (result is FilePickerResult) {
        for (var it in result.files) {
          if (null == it.path) continue;
          files.add(await JFile.fromPath(it.path!));
        }
      }
    }
    //判断最大选择数量，截取符合条件的集合
    if (files.length > maxCount) {
      files = files.sublist(0, maxCount);
    }
    return JPickerResult(files: files);
  }

  //附件选择
  static Future<dynamic> _pickFile(PickerMenuItem item, bool multiple) {
    switch (item.type) {
      case PickerType.image:
        if (multiple) {
          return ImagePicker().pickMultiImage(
            maxWidth: item.maxWidth,
            maxHeight: item.maxHeight,
            imageQuality: item.imageQuality,
          );
        } else {
          return ImagePicker().pickImage(
            source: ImageSource.gallery,
            maxWidth: item.maxWidth,
            maxHeight: item.maxHeight,
            imageQuality: item.imageQuality,
          );
        }
      case PickerType.imageTake:
        return ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: item.maxWidth,
          maxHeight: item.maxHeight,
          imageQuality: item.imageQuality,
          preferredCameraDevice:
              item.frontCamera ? CameraDevice.front : CameraDevice.rear,
        );
      case PickerType.video:
        if (multiple) {
          return FilePicker.platform.pickFiles(
            type: FileType.video,
            allowMultiple: multiple,
          );
        } else {
          return ImagePicker().pickVideo(
            source: ImageSource.gallery,
          );
        }
      case PickerType.videoRecord:
        return ImagePicker().pickVideo(
          source: ImageSource.camera,
          maxDuration: item.maxDuration,
          preferredCameraDevice:
              item.frontCamera ? CameraDevice.front : CameraDevice.rear,
        );
      case PickerType.custom:
        return FilePicker.platform.pickFiles(
          allowedExtensions: item.allowedExtensions,
          type: FileType.custom,
          allowMultiple: multiple,
        );
    }
  }
}
