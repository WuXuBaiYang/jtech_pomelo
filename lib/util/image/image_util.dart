import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jtech_pomelo/manage/router.dart';
import 'package:jtech_pomelo/util/file_util.dart';
import 'package:jtech_pomelo/util/image/editor_page.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/util/util.dart';

/*
* 图片工具方法
* @author JTech JH
* @Time 2022/3/31 17:27
*/
class JImageUtil {
  //图片类型后缀对照表
  static final Map<CompressFormat, String> _suffixMap = {
    CompressFormat.jpeg: ".jpeg",
    CompressFormat.heic: ".heic",
    CompressFormat.png: ".png",
    CompressFormat.webp: ".webp",
  };

  //图片压缩
  static Future<JFile> compress(
    Uint8List source, {
    String? fileName,
    int? minWidth,
    int? minHeight,
    int? quality,
    int? rotate,
    int? inSampleSize,
    bool? autoCorrectionAngle,
    CompressFormat? format,
    bool? keepExif,
  }) async {
    minWidth ??= 1920;
    minHeight ??= 1080;
    quality ??= 95;
    rotate ??= 0;
    inSampleSize ??= 1;
    autoCorrectionAngle ??= true;
    format ??= CompressFormat.jpeg;
    keepExif ??= false;
    fileName ??= "${JUtil.genID()}${_suffixMap[format]}";
    var values = await FlutterImageCompress.compressWithList(
      source,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      rotate: rotate,
      inSampleSize: inSampleSize,
      autoCorrectionAngle: autoCorrectionAngle,
      format: format,
      keepExif: keepExif,
    );
    var path = await JFileUtil.getImageCacheFilePath(fileName);
    var file = await File(path).writeAsBytes(values);
    return JFile.fromFile(file);
  }

  //图片压缩-传入file
  static Future<JFile> compressFile(
    File source, {
    String? fileName,
    int? minWidth,
    int? minHeight,
    int? quality,
    int? rotate,
    int? inSampleSize,
    bool? autoCorrectionAngle,
    CompressFormat? format,
    bool? keepExif,
  }) {
    return compress(
      source.readAsBytesSync(),
      fileName: fileName,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      rotate: rotate,
      inSampleSize: inSampleSize,
      autoCorrectionAngle: autoCorrectionAngle,
      format: format,
      keepExif: keepExif,
    );
  }

  //图片压缩-传入asset路径
  static Future<JFile> compressAsset(
    String source, {
    String? fileName,
    int? minWidth,
    int? minHeight,
    int? quality,
    int? rotate,
    int? inSampleSize,
    bool? autoCorrectionAngle,
    CompressFormat? format,
    bool? keepExif,
  }) async {
    var key = await AssetImage(source).obtainKey(
      const ImageConfiguration(),
    );
    final ByteData data = await key.bundle.load(key.name);
    final uint8List = data.buffer.asUint8List();
    return compress(
      uint8List,
      fileName: fileName,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      rotate: rotate,
      inSampleSize: inSampleSize,
      autoCorrectionAngle: autoCorrectionAngle,
      format: format,
      keepExif: keepExif,
    );
  }

  //图片裁剪
  static Future<JFile?>? crop({
    required JFile file,
    double? maxScale,
    double? initialCropRatio,
    bool? enableRatioMenu,
  }) {
    //默认值
    maxScale ??= 3.0;
    initialCropRatio ??= -1.0;
    enableRatioMenu ??= true;
    return jRouter.push<JFile>((_, anim, secAnim) {
      return ImageEditorPage(
        file: file,
        maxScale: maxScale!,
        initialCropRatio: initialCropRatio!,
        enableRatioMenu: enableRatioMenu!,
      );
    });
  }

  //图片裁剪-网络地址
  static Future<JFile?>? cropUrl({
    required String url,
    //默认字段
    double? maxScale,
    double? initialCropRatio,
    bool? enableRatioMenu,
  }) {
    return crop(
      file: JFile.fromUrl(url),
      maxScale: maxScale,
      initialCropRatio: initialCropRatio,
      enableRatioMenu: enableRatioMenu,
    );
  }

  //图片裁剪-本地路径
  static Future<JFile?>? cropPath({
    required String path,
    //默认字段
    double? maxScale,
    double? initialCropRatio,
    bool? enableRatioMenu,
  }) async {
    return crop(
      file: await JFile.fromPath(path),
      maxScale: maxScale,
      initialCropRatio: initialCropRatio,
      enableRatioMenu: enableRatioMenu,
    );
  }
}
