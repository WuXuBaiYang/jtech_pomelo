import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_editor/image_editor.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/util/file_util.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/util/util.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/image/clip.dart';

//图片加载构造器
typedef ImageBuilder = Widget Function(BuildContext context, Widget child);

//图片占位构造器
typedef PlaceholderBuilder = Widget Function(BuildContext context);

//图片异常占位构造器
typedef ErrorBuilder = Widget Function(
    BuildContext context, Object? error, StackTrace? stackTrace);

/*
* 图片组件
* @author JTech JH
* @Time 2022/3/30 17:08
*/
class JImage extends BaseStatefulWidget {
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

  //图片构造器
  final ImageBuilder? imageBuilder;

  //图片占位图构造器
  final PlaceholderBuilder? placeholderBuilder;

  //图片异常占位构造器
  final ErrorBuilder? errorBuilder;

  //图片裁剪构造
  final ImageClip? clip;

  //编辑控制key
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  //手势管理key
  final GlobalKey<ExtendedImageGestureState> gestureKey = GlobalKey();

  JImage({
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
    this.imageBuilder,
    this.placeholderBuilder,
    this.errorBuilder,
    this.clip,
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
    ImageBuilder? imageBuilder,
    PlaceholderBuilder? placeholderBuilder,
    ErrorBuilder? errorBuilder,
    ImageClip? clip,
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
          imageBuilder: imageBuilder,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          clip: clip,
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
    ImageBuilder? imageBuilder,
    PlaceholderBuilder? placeholderBuilder,
    ErrorBuilder? errorBuilder,
    ImageClip? clip,
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
          imageBuilder: imageBuilder,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          clip: clip,
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
    ImageBuilder? imageBuilder,
    PlaceholderBuilder? placeholderBuilder,
    ErrorBuilder? errorBuilder,
    ImageClip? clip,
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
          imageBuilder: imageBuilder,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          clip: clip,
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
    ImageBuilder? imageBuilder,
    PlaceholderBuilder? placeholderBuilder,
    ErrorBuilder? errorBuilder,
    ImageClip? clip,
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
          imageBuilder: imageBuilder,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          clip: clip,
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
    ImageBuilder? imageBuilder,
    PlaceholderBuilder? placeholderBuilder,
    ErrorBuilder? errorBuilder,
    ImageClip? clip,
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
          imageBuilder: imageBuilder,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          clip: clip,
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
    ImageBuilder? imageBuilder,
    PlaceholderBuilder? placeholderBuilder,
    ErrorBuilder? errorBuilder,
    ImageClip? clip,
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
          imageBuilder: imageBuilder,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          clip: clip,
        );

  @override
  State<StatefulWidget> createState() => _JImageState();
}

/*
* 图片组件-状态
* @author JTech JH
* @Time 2022/3/30 17:08
*/
class _JImageState extends BaseState<JImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ExtendedImage(
        image: widget.image,
        width: widget.width,
        height: widget.height,
        fit: widget.mode == ExtendedImageMode.editor
            ? BoxFit.contain
            : widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        color: widget.color,
        colorBlendMode: widget.blendMode,
        mode: widget.mode,
        initEditorConfigHandler: (state) => widget.editorConfig,
        extendedImageEditorKey: widget.editorKey,
        initGestureConfigHandler: (state) =>
            widget.gestureConfig ?? GestureConfig(),
        extendedImageGestureKey: widget.gestureKey,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading: //加载占位图
              return _buildPlaceholder(context, state);
            case LoadState.completed: //完成加载
              return _buildImage(context, state);
            case LoadState.failed: //加载失败
              return _buildError(context, state);
          }
        },
      ),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }

  //构建构造器
  Widget _buildPlaceholder(BuildContext context, ExtendedImageState state) {
    return widget.placeholderBuilder?.call(context) ?? const EmptyBox();
  }

  //构建图片
  Widget _buildImage(BuildContext context, ExtendedImageState state) {
    var child = state.completedWidget;
    child = widget.imageBuilder?.call(context, child) ?? child;
    return widget.clip?.clip(context, child) ?? child;
  }

  //构建加载失败
  Widget _buildError(BuildContext context, ExtendedImageState state) {
    return widget.errorBuilder
            ?.call(context, state.lastException, state.lastStack) ??
        const EmptyBox();
  }

  //手势重置
  void gestureReset() => widget.gestureKey.currentState?.reset();

  //手势滑动
  void gestureSlide() => widget.gestureKey.currentState?.slide();

  //手势图片缩放
  void gestureScale({double? scale, Offset? position}) =>
      widget.gestureKey.currentState
          ?.handleDoubleTap(scale: scale, doubleTapPosition: position);

  //编辑顺时针旋转90度
  void editorRotateRight90() =>
      widget.editorKey.currentState?.rotate(right: true);

  //编辑逆时针旋转90度
  void editorRotateLeft90() =>
      widget.editorKey.currentState?.rotate(right: false);

  //编辑镜像翻转
  void editorFlip() => widget.editorKey.currentState?.flip();

  //编辑重置
  void editorReset() => widget.editorKey.currentState?.reset();

  //编辑执行裁剪并获取到裁剪后的数据
  Future<JFile?> editorCropImage() async {
    var currentState = widget.editorKey.currentState;
    if (null == currentState) return null;
    var cropRect = currentState.getCropRect();
    var imageData = currentState.rawImageData;
    var action = currentState.editAction;
    if (null == action) return null;
    var rotateAngle = action.rotateAngle.toInt();
    var flipHorizontal = action.flipY;
    var flipVertical = action.flipX;
    ImageEditorOption editorOption = ImageEditorOption();
    //添加裁剪方法
    if (action.needCrop && null != cropRect) {
      editorOption.addOption(ClipOption.fromRect(cropRect));
    }
    //添加镜像翻转方法
    if (action.needFlip) {
      editorOption.addOption(FlipOption(
        horizontal: flipHorizontal,
        vertical: flipVertical,
      ));
    }
    //添加旋转方法
    if (action.hasRotateAngle) {
      editorOption.addOption(RotateOption(rotateAngle));
    }
    var result = await ImageEditor.editImage(
      image: imageData,
      imageEditorOption: editorOption,
    );
    if (null == result) return null;
    return JFile.fromMemory(
      result,
      fileName: "${JUtil.genID()}.jpeg",
      cachePath: await JFileUtil.getImageCacheDirPath(),
    );
  }
}
