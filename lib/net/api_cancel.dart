import 'package:dio/dio.dart';
import 'package:jtech_pomelo/base/base_manage.dart';


/*
* 请求撤销管理
* @author JTech JH
* @Time 2022/3/29 14:54
*/
class JAPICancelManage extends BaseManage {
  static final JAPICancelManage _instance = JAPICancelManage._internal();

  factory JAPICancelManage() => _instance;

  JAPICancelManage._internal();

  //缓存接口取消key
  final Map<String, JCancelToken> _cancelKeyMap = {};

  //生成一个取消授权并返回
  JCancelToken generateToken(String key) {
    if (null != _cancelKeyMap[key]) {
      return _cancelKeyMap[key]!;
    }
    var cancelToken = JCancelToken();
    _cancelKeyMap[key] = cancelToken;
    return cancelToken;
  }

  //判断请求是否已取消
  bool isCanceled(String key) => _cancelKeyMap[key]?.isCancelled ?? true;

  //移除并取消请求
  void cancel(String key, {String? reason}) =>
      _cancelKeyMap.remove(key)?.cancel(reason);

  //取消所有请求
  void cancelAll({String? reason}) => _cancelKeyMap.removeWhere((key, value) {
        value.cancel(reason);
        return true;
      });
}

//单例调用
final jAPICancel = JAPICancelManage();

/*
* 请求撤销token
* @author JTech JH
* @Time 2022/3/29 14:54
*/
class JCancelToken extends CancelToken {}
