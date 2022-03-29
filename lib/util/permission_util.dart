import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:jtech_pomelo/base/base_model.dart';
import 'package:jtech_pomelo/util/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';

//回调请求失败的请求
typedef OnPermissionCheckFail = void Function(
    List<PermissionResult> failRequests);

/*
* 权限管理工具方法
* @author JTech JH
* @Time 2022/3/18 13:48
*/
class JPermissionUtil {
  //检查集合中的权限是否全部通过
  //默认将请求失败的权限通过toast提示出来，当回调不为空时则不进行toast提示
  static Future<bool> checkAllGranted(
    BuildContext context, {
    required List<PermissionRequest> permissions,
    OnPermissionCheckFail? onCheckFail,
  }) async {
    List<PermissionResult> failResults = [];
    for (var item in permissions) {
      var result = await item.request();
      if (!result.isGranted) failResults.add(result);
    }
    if (failResults.isEmpty) return true;
    if (null != onCheckFail) {
      onCheckFail.call(failResults);
    } else {
      var message = failResults.map<String>((e) => e.message).join(";");
      JToastUtil.show(message);
    }
    return false;
  }

  //检查日历权限
  static Future<bool> checkCalendar(
    BuildContext context, {
    String? requestMessage,
    String? requestFail,
  }) async {
    var result = await PermissionRequest.calendar(
      requestMessage: requestMessage,
      requestFail: requestFail,
    ).request();
    return result.isGranted;
  }

  ///待完成
}

/*
* 权限请求实体
* @author JTech JH
* @Time 2022/3/18 13:49
*/
class PermissionRequest extends BaseModel {
  //要申请的权限
  final Permission _permission;

  //权限申请描述
  final String requestMessage;

  //权限申请失败提示
  final String requestFail;

  //请求权限
  Future<PermissionResult> request() async {
    var status = await _permission.request();
    return PermissionResult.from(status,
        message: !status.isGranted ? requestFail : "");
  }

  //日历权限
  PermissionRequest.calendar({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.calendar,
        requestMessage = requestMessage ?? "请求日历权限",
        requestFail = requestFail ?? "日历权限请求失败";

  //摄像头权限
  PermissionRequest.camera({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.camera,
        requestMessage = requestMessage ?? "请求摄像头权限",
        requestFail = requestFail ?? "摄像头权限请求失败";

  //请求通讯录权限
  PermissionRequest.contacts({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.contacts,
        requestMessage = requestMessage ?? "请求通讯录权限",
        requestFail = requestFail ?? "通讯录权限请求失败";

  //请求定位权限(locationAlways、locationWhenInUse)
  PermissionRequest.location({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.location,
        requestMessage = requestMessage ?? "请求定位权限",
        requestFail = requestFail ?? "定位权限请求失败";

  //请求麦克风权限
  PermissionRequest.microphone({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.microphone,
        requestMessage = requestMessage ?? "请求麦克风权限",
        requestFail = requestFail ?? "麦克风权限请求失败";

  //请求传感器权限
  PermissionRequest.sensors({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.sensors,
        requestMessage = requestMessage ?? "请求传感器权限",
        requestFail = requestFail ?? "传感器权限请求失败";

  //请求麦克风权限
  PermissionRequest.speech({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.speech,
        requestMessage = requestMessage ?? "请求麦克风权限",
        requestFail = requestFail ?? "麦克风权限请求失败";

  //请求存储权限
  PermissionRequest.storage({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.storage,
        requestMessage = requestMessage ?? "请求存储权限",
        requestFail = requestFail ?? "存储权限请求失败";

  //请求通知权限
  PermissionRequest.notification({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.notification,
        requestMessage = requestMessage ?? "请求通知权限",
        requestFail = requestFail ?? "通知权限请求失败";

  //请求蓝牙权限
  PermissionRequest.bluetooth({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.bluetooth,
        requestMessage = requestMessage ?? "请求蓝牙权限",
        requestFail = requestFail ?? "蓝牙权限请求失败";

  //请求媒体库权限
  PermissionRequest.iosMediaLibrary({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.mediaLibrary,
        requestMessage = requestMessage ?? "请求媒体库权限",
        requestFail = requestFail ?? "媒体库权限请求失败";

  //请求图片库权限
  PermissionRequest.iosPhotos({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.photos,
        requestMessage = requestMessage ?? "请求图片库权限",
        requestFail = requestFail ?? "图片库权限请求失败";

  //请求提醒事项权限
  PermissionRequest.iosReminders({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.reminders,
        requestMessage = requestMessage ?? "请求提醒事项权限",
        requestFail = requestFail ?? "提醒事项权限请求失败";

  //请求外部存储权限
  PermissionRequest.androidManageExternalStorage({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.bluetooth,
        requestMessage = requestMessage ?? "请求外部存储权限",
        requestFail = requestFail ?? "外部存储权限请求失败";

  //请求系统通知权限
  PermissionRequest.androidSystemAlertWindow({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.systemAlertWindow,
        requestMessage = requestMessage ?? "请求系统通知权限",
        requestFail = requestFail ?? "系统通知权限请求失败";

  //请求安装包权限
  PermissionRequest.androidRequestInstallPackages({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.requestInstallPackages,
        requestMessage = requestMessage ?? "请求安装包权限",
        requestFail = requestFail ?? "安装包权限请求失败";

  //请求短信权限
  PermissionRequest.androidSms({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.sms,
        requestMessage = requestMessage ?? "请求短信权限",
        requestFail = requestFail ?? "短信权限请求失败";

  //请求拨打电话权限
  PermissionRequest.androidPhone({
    String? requestMessage,
    String? requestFail,
  })  : _permission = Permission.phone,
        requestMessage = requestMessage ?? "请求拨打电话权限",
        requestFail = requestFail ?? "拨打电话权限请求失败";
}

/*
* 权限请求结果
* @author JTech JH
* @Time 2022/3/18 13:49
*/
class PermissionResult extends BaseModel {
  //存储权限申请结果
  final PermissionStatus _status;

  //提示消息
  final String message;

  PermissionResult.from(
    PermissionStatus status, {
    this.message = "",
  }) : _status = status;

  //判断是否通过
  bool get isGranted => _status.isGranted;

  //判断是否失败
  bool get isDenied => _status.isDenied;
}
