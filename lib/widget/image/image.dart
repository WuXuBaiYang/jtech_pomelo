import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jtech_pomelo/pomelo.dart';
import 'package:jtech_pomelo/widget/image/controller.dart';

/*
* 图片组件
* @author JTech JH
* @Time 2022/3/30 17:08
*/
class JImage extends BaseStatelessWidget {
  //图片对象代理
  final ImageProvider image;

  //图片宽度
  final double? width;

  //图片高度
  final double? height;

  //填充方式
  final BoxFit? fit;

  //点击事件
  final VoidCallback? onTap;

  //长点击事件
  final VoidCallback? onLongPress;

  //调色
  final Color? color;

  //调色模式
  final BlendMode? blendMode;

  //对齐方式
  final Alignment alignment;

  //图片重复方式
  final ImageRepeat repeat;

  //绘制清晰度
  final FilterQuality filterQuality;

  //图片模式
  final ExtendedImageMode mode;

  //编辑模式配置
  final EditorConfig? editorConfig;

  //缩放模式配置
  final GestureConfig? gestureConfig;

  //图片控制器
  final ImageController? controller;

  const JImage({
    Key? key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.onTap,
    this.onLongPress,
    this.color,
    this.blendMode,
    this.editorConfig,
    this.gestureConfig,
    this.controller,
    Alignment? alignment,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    ExtendedImageMode? mode,
  })  : alignment = alignment ?? Alignment.center,
        repeat = repeat ?? ImageRepeat.noRepeat,
        filterQuality = filterQuality ?? FilterQuality.low,
        mode = mode ?? ExtendedImageMode.none,
        super(key: key);

  //从JFile文件中加载
  JImage.jFile(
    JFile file, {
    String? cacheKey,
    Map<String, String>? headers,
    bool cacheRawData = false,
    //基础参数
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Alignment? alignment,
    ImageRepeat? repeat,
    Color? color,
    BlendMode? blendMode,
    FilterQuality? filterQuality,
    ExtendedImageMode? mode,
    EditorConfig? editorConfig,
    GestureConfig? gestureConfig,
    ImageController? controller,
  }) : this(
          key: key,
          image: file.isNetFile
              ? ExtendedNetworkImageProvider(
                  file.uri,
                  cacheKey: cacheKey,
                  headers: headers,
                  cacheRawData: cacheRawData,
                )
              : ExtendedFileImageProvider(
                  file.file!,
                  cacheRawData: cacheRawData,
                ) as ImageProvider,
          width: width,
          height: height,
          fit: fit,
          onTap: onTap,
          onLongPress: onLongPress,
          alignment: alignment,
          repeat: repeat,
          color: color,
          blendMode: blendMode,
          filterQuality: filterQuality,
          mode: mode,
          editorConfig: editorConfig,
          gestureConfig: gestureConfig,
          controller: controller,
        );

  //本地图片文件路径
  JImage.path(
    String path, {
    bool cacheRawData = false,
    //基础参数
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Alignment? alignment,
    ImageRepeat? repeat,
    Color? color,
    BlendMode? blendMode,
    FilterQuality? filterQuality,
    ExtendedImageMode? mode,
    EditorConfig? editorConfig,
    GestureConfig? gestureConfig,
    ImageController? controller,
  }) : this.file(
          File(path),
          key: key,
          cacheRawData: cacheRawData,
          width: width,
          height: height,
          fit: fit,
          onTap: onTap,
          onLongPress: onLongPress,
          alignment: alignment,
          repeat: repeat,
          color: color,
          blendMode: blendMode,
          filterQuality: filterQuality,
          mode: mode,
          editorConfig: editorConfig,
          gestureConfig: gestureConfig,
          controller: controller,
        );

  //本地图片文件
  JImage.file(
    File file, {
    bool cacheRawData = false,
    //基础参数
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Alignment? alignment,
    ImageRepeat? repeat,
    Color? color,
    BlendMode? blendMode,
    FilterQuality? filterQuality,
    ExtendedImageMode? mode,
    EditorConfig? editorConfig,
    GestureConfig? gestureConfig,
    ImageController? controller,
  }) : this(
          key: key,
          image: ExtendedFileImageProvider(
            file,
            cacheRawData: cacheRawData,
          ),
          width: width,
          height: height,
          fit: fit,
          onTap: onTap,
          onLongPress: onLongPress,
          alignment: alignment,
          repeat: repeat,
          color: color,
          blendMode: blendMode,
          filterQuality: filterQuality,
          mode: mode,
          editorConfig: editorConfig,
          gestureConfig: gestureConfig,
          controller: controller,
        );

  //assets图片文件
  JImage.assets(
    String name, {
    AssetBundle? bundle,
    String? package,
    bool cacheRawData = false,
    //基础参数
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Alignment? alignment,
    ImageRepeat? repeat,
    Color? color,
    BlendMode? blendMode,
    FilterQuality? filterQuality,
    ExtendedImageMode? mode,
    EditorConfig? editorConfig,
    GestureConfig? gestureConfig,
    ImageController? controller,
  }) : this(
          key: key,
          image: ExtendedAssetImageProvider(
            name,
            bundle: bundle,
            package: package,
            cacheRawData: cacheRawData,
          ),
          width: width,
          height: height,
          fit: fit,
          onTap: onTap,
          onLongPress: onLongPress,
          alignment: alignment,
          repeat: repeat,
          color: color,
          blendMode: blendMode,
          filterQuality: filterQuality,
          mode: mode,
          editorConfig: editorConfig,
          gestureConfig: gestureConfig,
          controller: controller,
        );

  //内存图片文件
  JImage.memory(
    Uint8List bytes, {
    bool cacheRawData = false,
    //基础参数
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Alignment? alignment,
    ImageRepeat? repeat,
    Color? color,
    BlendMode? blendMode,
    FilterQuality? filterQuality,
    ExtendedImageMode? mode,
    EditorConfig? editorConfig,
    GestureConfig? gestureConfig,
    ImageController? controller,
  }) : this(
          key: key,
          image: ExtendedMemoryImageProvider(
            bytes,
            cacheRawData: cacheRawData,
          ),
          width: width,
          height: height,
          fit: fit,
          onTap: onTap,
          onLongPress: onLongPress,
          alignment: alignment,
          repeat: repeat,
          color: color,
          blendMode: blendMode,
          filterQuality: filterQuality,
          mode: mode,
          editorConfig: editorConfig,
          gestureConfig: gestureConfig,
          controller: controller,
        );

  //网络图片文件
  JImage.net(
    String imageUrl, {
    String? cacheKey,
    Map<String, String>? headers,
    bool cacheRawData = false,
    //基础参数
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Alignment? alignment,
    ImageRepeat? repeat,
    Color? color,
    BlendMode? blendMode,
    FilterQuality? filterQuality,
    ExtendedImageMode? mode,
    EditorConfig? editorConfig,
    GestureConfig? gestureConfig,
    ImageController? controller,
  }) : this(
          key: key,
          image: ExtendedNetworkImageProvider(
            imageUrl,
            cacheKey: cacheKey,
            headers: headers,
            cacheRawData: cacheRawData,
          ),
          width: width,
          height: height,
          fit: fit,
          onTap: onTap,
          onLongPress: onLongPress,
          alignment: alignment,
          repeat: repeat,
          color: color,
          blendMode: blendMode,
          filterQuality: filterQuality,
          mode: mode,
          editorConfig: editorConfig,
          gestureConfig: gestureConfig,
          controller: controller,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ExtendedImage(
        image: image,
        width: width,
        height: height,
        fit: mode == ExtendedImageMode.editor ? BoxFit.contain : fit,
        alignment: alignment,
        repeat: repeat,
        color: color,
        colorBlendMode: blendMode,
        mode: mode,
        initEditorConfigHandler: (state) => editorConfig,
        extendedImageEditorKey: controller?.editorKey,
        initGestureConfigHandler: (state) => gestureConfig ?? GestureConfig(),
        extendedImageGestureKey: controller?.gestureKey,
        loadStateChanged: (state) {
          ///等待实现
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return (config.placeholderBuilder ?? _buildPlaceholder)(context);
            case LoadState.completed:
              return (config.imageBuilder ?? _buildImage)(
                  context, state.completedWidget);
            case LoadState.failed:
              return (config.errorBuilder ?? _buildError)(
                  context, state.lastException, state.lastStack);
          }
        },
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
