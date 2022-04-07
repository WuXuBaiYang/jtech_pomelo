import 'package:azlistview/azlistview.dart';
import 'package:jtech_pomelo/util/match_util.dart';
import 'package:lpinyin/lpinyin.dart';

/*
* 索引列表数据对象基类
* @author JTech JH
* @Time 2022/4/7 14:34
*/
abstract class BaseIndexModel extends ISuspensionBean {
  //标签
  final String tag;

  //标签拼音
  late String tagPinyin;

  //标签索引
  late String tagIndex;

  BaseIndexModel.create({required this.tag, String defIndex = "#"}) {
    if (tag.isNotEmpty) {
      tagPinyin = PinyinHelper.getPinyinE(tag);
      var tempIndex = tagPinyin.substring(0, 1).toUpperCase();
      var hasIndex = JMatchUtil.hasMatch(RegExp("[A-Z]"), string: tempIndex);
      tagIndex = hasIndex ? tempIndex : defIndex;
    } else {
      tagPinyin = tagIndex = defIndex;
    }
  }

  @override
  String getSuspensionTag() => tagIndex;
}
