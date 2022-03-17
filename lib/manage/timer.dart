import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../base/base_manage.dart';
import '../utils/data_util.dart';
import '../utils/util.dart';

//循环计时器回调
typedef OnTimerCallback = void Function(Timer timer);
//倒计时回调
typedef OnCountDownTimerCallback = void Function(
    Duration remaining, Duration passTime);

/*
* 计时器管理
* @author jtechjh
* @Time 2021/8/4 5:08 下午
*/
class JTimer extends BaseManage {
  static final JTimer _instance = JTimer._internal();

  factory JTimer() => _instance;

  JTimer._internal();

  //缓存计时器
  final Map<String, Timer> cacheTimers = {};

  //启动一个循环计时器
  String? periodic({
    String? key,
    required Duration duration,
    required OnTimerCallback callback,
  }) {
    if (duration.greaterThanZero) {
      key ??= JUtil.genID();
      getTimer(key)?.cancel();
      cacheTimers[key] = Timer.periodic(duration, callback);
    }
    return key;
  }

  //启动一个倒计时
  String? countdown({
    String? key,
    required Duration maxDuration,
    Duration tickDuration = const Duration(seconds: 1),
    required OnCountDownTimerCallback callback,
    required VoidCallback onFinish,
  }) {
    if (maxDuration.greaterThanZero &&
        tickDuration.greaterThanZero &&
        maxDuration.greaterThan(tickDuration)) {
      key ??= JUtil.genID();
      getTimer(key)?.cancel();
      cacheTimers[key] = Timer.periodic(tickDuration, (timer) {
        var passTime = tickDuration.multiply(timer.tick);
        var remaining = maxDuration.subtract(passTime);
        if (remaining.lessEqualThanZero) {
          remaining = Duration.zero;
          timer.cancel();
        }
        callback(remaining, passTime);
        if (!timer.isActive) onFinish();
      });
    }
    return key;
  }

  //启动一个区间计时器
  String? inTime({
    String? key,
    required Duration duration,
    required VoidCallback callback,
  }) {
    if (duration.greaterThanZero) {
      key ??= JUtil.genID();
      getTimer(key)?.cancel();
      cacheTimers[key] = Timer(duration, callback);
    }
    return key;
  }

  //在目标时间提醒
  String? onTime({
    String? key,
    required DateTime dateTime,
    required VoidCallback callback,
  }) =>
      inTime(
        duration: dateTime.difference(DateTime.now()),
        callback: callback,
      );

  //获取一个计时器
  Timer? getTimer(String key) => cacheTimers[key];

  //判断目标计时器是否活动
  bool isActive(String key) => getTimer(key)?.isActive ?? false;

  //取消指定计时器
  void cancel(String key) => cacheTimers.remove(key)?.cancel();

  //取消所有计时器
  void cancelAll() => cacheTimers.removeWhere((key, value) {
        value.cancel();
        return true;
      });
}

//单例调用
final jTimer = JTimer();
