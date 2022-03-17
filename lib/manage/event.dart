import '../base/base_manage.dart';
import '../base/base_model.dart';
import 'dart:async';

/*
* 消息总线管理
* @author JTech JH
* @Time 2022/3/17 14:14
*/
class JEvent extends BaseManage {
  static final JEvent _instance = JEvent._internal();

  factory JEvent() => _instance;

  //流控制器
  final StreamController _streamController;

  JEvent._internal()
      : _streamController = StreamController.broadcast(sync: false);

  //注册事件
  Stream<T> on<T extends EventModel>() {
    if (T == EventModel) {
      return _streamController.stream as Stream<T>;
    } else {
      return _streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  //发送事件
  void send<T extends EventModel>(T event) => _streamController.add(event);

  //销毁消息总线
  void destroy() => _streamController.close();
}

//单例调用
final jEvent = JEvent();

/*
* 消息总线对象基类
* @author JTech JH
* @Time 2022/3/17 14:15
*/
abstract class EventModel extends BaseModel {}
