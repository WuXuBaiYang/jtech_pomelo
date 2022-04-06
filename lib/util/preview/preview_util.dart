import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/manage/router.dart';
import 'package:jtech_pomelo/util/match_util.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/util/preview/options_item.dart';
import 'package:jtech_pomelo/util/preview/preview_page.dart';

/*
* 预览工具方法
* @author JTech JH
* @Time 2022/3/30 13:55
*/
class JPreviewUtil {
  //附件预览基本方法
  static Future<void>? preview({
    required List<PreviewOptionItem> items,
    ItemBuilder<PreviewOptionItem>? itemBuilder,
    int? initialIndex,
  }) {
    initialIndex ??= 0;
    return jRouter.push<void>(
      (_, anim, secAnim) => PreviewPage(
        items: items,
        itemBuilder: itemBuilder,
        initialIndex: initialIndex!,
      ),
      opaque: false,
      transitionsBuilder: (_, anim, secAnim, child) => FadeTransition(
        opacity: anim,
        child: child,
      ),
    );
  }

  //预览图片集合
  static Future<void>? previewImages({
    required List<String> imageList,
    ItemBuilder<PreviewOptionItem>? itemBuilder,
    int? initialIndex,
  }) async {
    List<PreviewOptionItem> items = [];
    for (var e in imageList) {
      items.add(PreviewOptionItem.image(
        file: JMatchUtil.isHttpProtocol(e)
            ? JFile.fromUrl(e)
            : await JFile.fromPath(e),
      ));
    }
    return preview(
      items: items,
      itemBuilder: itemBuilder,
      initialIndex: initialIndex,
    );
  }

  //预览视频集合
  static Future<void>? previewVideos({
    required List<String> videoList,
    ItemBuilder<PreviewOptionItem>? itemBuilder,
    int? initialIndex,
  }) async {
    List<PreviewOptionItem> items = [];
    for (var e in videoList) {
      items.add(PreviewOptionItem.video(
        file: JMatchUtil.isHttpProtocol(e)
            ? JFile.fromUrl(e)
            : await JFile.fromPath(e),
      ));
    }
    return preview(
      items: items,
      itemBuilder: itemBuilder,
      initialIndex: initialIndex,
    );
  }
}
