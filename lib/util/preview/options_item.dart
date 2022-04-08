import 'package:jtech_pomelo/model/option_item.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';

/*
* 附件预览项
* @author JTech JH
* @Time 2022/3/30 13:56
*/
class PreviewOptionItem extends OptionItem {
  //预览附件类型
  final PreviewType type;

  //附件对象
  final JFile file;

  PreviewOptionItem({
    required this.type,
    required this.file,
    //基础方法
    String? text,
    String? id,
    bool? enable,
  }) : super(
          text: text ?? "",
          id: id,
          enable: enable,
        );

  //由JFile确定类型附件
  PreviewOptionItem.jFile({
    required JFile file,
    //基础方法
    String? text,
    String? id,
    bool? enable,
  }) : this(
          file: file,
          type: file.isImageType
              ? PreviewType.image
              : (file.isVideoType ? PreviewType.video : PreviewType.other),
          text: text,
          id: id,
          enable: enable,
        );

  //图片类型附件
  PreviewOptionItem.image({
    required JFile file,
    //基础方法
    String? text,
    String? id,
    bool? enable,
  }) : this(
          file: file,
          type: PreviewType.image,
          text: text,
          id: id,
          enable: enable,
        );

  //视频类型附件
  PreviewOptionItem.video({
    required JFile file,
    //基础方法
    String? text,
    String? id,
    bool? enable,
  }) : this(
          file: file,
          type: PreviewType.video,
          text: text,
          id: id,
          enable: enable,
        );

  //其他类型附件
  PreviewOptionItem.other({
    required JFile file,
    //基础方法
    String? text,
    String? id,
    bool? enable,
  }) : this(
          file: file,
          type: PreviewType.other,
          text: text,
          id: id,
          enable: enable,
        );

  //判断是否为网络地址
  bool get isNetFile => file.isNetFile;
}

/*
* 附件预览项附件类型
* @author JTech JH
* @Time 2022/3/30 13:57
*/
enum PreviewType {
  image,
  video,
  other,
}
