import 'dart:io';
import 'dart:typed_data';
import 'package:jtech_pomelo/net/request.dart';
import 'package:jtech_pomelo/util/file_util.dart';
import 'package:jtech_pomelo/util/match_util.dart';
import 'package:jtech_pomelo/util/util.dart';

/*
* 选择器返回值
* @author JTech JH
* @Time 2022/3/29 17:19
*/
class JPickerResult {
  //已选择文件集合
  final List<JFile> files;

  JPickerResult({
    required this.files,
  });

  //判断是否为空
  bool get isEmpty => files.isEmpty;

  //判断是否非空
  bool get isNoEmpty => files.isNotEmpty;

  //判断是否为单文件
  bool get isSingle => files.length == 1;

  //获取文件数量
  int get length => files.length;

  //获取单文件
  JFile? get singleFile {
    if (isSingle) return files.first;
    return null;
  }

  //转换为接口请求的文件集合类型
  List<RequestFileItem> toRequestFiles() => files
      .map<RequestFileItem>((item) => RequestFileItem(
            filePath: item.uri,
            filename: item.name,
          ))
      .toList();
}

/*
* 附件信息
* @author JTech JH
* @Time 2022/3/29 17:22
*/
class JFile {
  //文件地址
  final String uri;

  //文件名称
  final String? name;

  //文件大小
  final int? length;

  //文件后缀
  final String? suffixes;

  JFile({
    required this.uri,
    this.name,
    this.length,
    this.suffixes,
  });

  //从网络地址中加载
  static JFile fromUrl(
    String url, {
    String? suffixes,
    String? name,
    int? length,
  }) =>
      JFile(
        uri: url,
        name: name,
        length: length,
        suffixes: suffixes,
      );

  //从文件路径中加载
  static Future<JFile> fromPath(String path) => fromFile(File(path));

  //从文件中加载
  static Future<JFile> fromFile(File file) async => JFile(
        uri: file.path,
        length: await file.length(),
        name: file.name,
        suffixes: file.suffixes,
      );

  //从内存中加载
  static Future<JFile> fromMemory(
    Uint8List bytes, {
    required String fileName,
    String? cachePath,
  }) async {
    cachePath ??= await JFileUtil.getCacheDirPath();
    var file = File(join(cachePath, fileName));
    file = await file.writeAsBytes(bytes);
    return JFile(
      uri: file.path,
      length: await file.length(),
      name: file.name,
      suffixes: file.suffixes,
    );
  }

  //获取为file类型
  File? get file => isLocalFile ? File(uri) : null;

  //判断是否为本地文件
  bool get isLocalFile => !isNetFile;

  //判断是否为网络文件
  bool get isNetFile => JMatchUtil.isHttpProtocol(uri);

  //判断文件类型是否为图片
  bool get isImageType => JMatchUtil.isImageFile("$uri$suffixes");

  //判断文件类型是否为视频
  bool get isVideoType => JMatchUtil.isVideoFile("$uri$suffixes");
}
