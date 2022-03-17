/*
* 匹配工具方法
* @author JTech JH
* @Time 2022/3/17 15:45
*/
class JMatchUtil {
  //判断是否存在匹配内容
  bool hasMatch(Pattern pattern, {required String string}) =>
      match(pattern, string: string).isNotEmpty;

  //匹配所有内容
  Iterable<Match> match(Pattern pattern, {required String string}) =>
      pattern.allMatches(string);
}

/*
* 匹配模型
* @author JTech JH
* @Time 2022/3/17 15:46
*/
class JMatchReg {
  //手机号匹配(+86)
  static const phoneNumber_86 =
      r'^((\+86)?|(\+86-)?)1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$';

  //邮箱匹配
  static const emailAddress =
      r'^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$';

  //身份证号匹配
  static const idCard = r'(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)';

  //文件类型匹配-图片
  static const imageFileType =
      r'xbm|tif|pjp|svgz|jpg|jpeg|ico|tiff|gif|svg|jfif|webp|png|bmp|pjpeg|avif';

  //文件类型匹配-视频
  static const videoFileType = r'mp4|avi|wmv|mpg|mpeg|mov|rm|ram|swf|flv';

  //文件类型匹配-音频
  static const audioFileType =
      r'opus|flac|webm|weba|wav|ogg|m4a|mp3|oga|mid|amr|aiff|wma|au|aac';
}
