import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:image_editor/image_editor.dart';
import 'package:jtech_pomelo/base/base_controller.dart';
import 'package:jtech_pomelo/pomelo.dart';

/*
* 图片编辑控制器
* @author JTech JH
* @Time 2022/3/30 17:32
*/
class ImageController extends BaseController {
  //编辑控制key
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  //手势管理key
  final GlobalKey<ExtendedImageGestureState> gestureKey = GlobalKey();

  //顺时针旋转90度
  void editorRotateRight90() => editorKey.currentState?.rotate(right: true);

  //逆时针旋转90度
  void editorRotateLeft90() => editorKey.currentState?.rotate(right: false);

  //镜像翻转
  void editorFlip() => editorKey.currentState?.flip();

  //重置状态
  void editorReset() => editorKey.currentState?.reset();

  void gestureReset() => gestureKey.currentState?.reset();

  //滑动
  void gestureSlide() => gestureKey.currentState?.slide();

  //图片缩放
  void gestureScale({double? scale, Offset? position}) =>
      gestureKey.currentState
          ?.handleDoubleTap(scale: scale, doubleTapPosition: position);

  //执行裁剪并获取到裁剪后的数据
  Future<JFile?> editorCropImage() async {
    var currentState = editorKey.currentState;
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
