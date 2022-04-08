import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:jtech_pomelo/util/log_util.dart';
import 'package:jtech_pomelo/util/toast_util.dart';
import 'package:jtech_pomelo/util/util.dart';
import 'package:url_launcher/url_launcher.dart';

/*
* 应用更新检查工具方法
* @author JTech JH
* @Time 2022/4/8 10:26
*/
class JUpdateUtil {
  //检查版本更新
  //android需要在android/app/src/main/res/values/styles.xml 中替换下列标签
  //<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
  //    <item name="android:windowBackground">@drawable/launch_background</item>
  //</style>
  static Future<bool> check({
    String androidOTAUrl = "",
    String androidOTAThemeColor = "",
    //自定义ota顶部图片资源，需要在
    //android/app/src/main/res/drawable/{androidOTATopImageRes} 中放入资源
    String androidOTATopImageRes = "",
    double androidOTAWidthRatio = 0.85,
    bool androidOTAWIFIOnly = false,
    ErrorHandler? androidOTAErrorHandler,
    ParseHandler? androidOTAUpdateParse,
    bool androidOTAUpdate = true,
    String androidPackageName = "",
    String iosAppId = "",
    String iosMt = "8",
  }) async {
    try {
      if (Platform.isAndroid) {
        if (androidOTAUpdate) {
          var c = Completer<bool>();
          await FlutterXUpdate.init(
            debug: debugMode,
            isWifiOnly: androidOTAWIFIOnly,
          );
          FlutterXUpdate.setErrorHandler(
            onUpdateError: androidOTAErrorHandler,
          );
          FlutterXUpdate.setCustomParseHandler(
            onUpdateParse: (json) async {
              var entry = await androidOTAUpdateParse?.call(json) ??
                  UpdateEntity(
                    hasUpdate: false,
                    versionCode: 0,
                    versionName: '',
                    updateContent: '',
                    downloadUrl: '',
                  );
              c.complete(entry.hasUpdate ?? false);
              return entry;
            },
          );
          FlutterXUpdate.checkUpdate(
            url: androidOTAUrl,
            isCustomParse: true,
            supportBackgroundUpdate: true,
            themeColor: androidOTAThemeColor,
            topImageRes: androidOTATopImageRes,
            widthRatio: androidOTAWidthRatio,
          );
          return c.future;
        }
        var uri = "market://details?id=$androidPackageName";
        return _doSysLaunch(uri);
      } else if (Platform.isIOS) {
        var uri = "itms-apps://itunes.apple.com/cn/app/$iosAppId?mt=$iosMt";
        return _doSysLaunch(uri);
      }
      JToastUtil.showShort("暂不支持该平台");
    } catch (e) {
      JLogUtil.e(e.toString());
    }
    return false;
  }

  //使用phoneQ平台的版本更新检查
  //android需要在android/app/src/main/res/values/styles.xml 中替换下列标签
  //<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
  //    <item name="android:windowBackground">@drawable/launch_background</item>
  //</style>
  static Future<bool> checkByPhoneQ({
    required String appName,
    String androidOTAThemeColor = "",
    //自定义ota顶部图片资源，需要在
    //android/app/src/main/res/drawable/{androidOTATopImageRes} 中放入资源
    String androidOTATopImageRes = "",
    double androidOTAWidthRatio = 0.85,
    bool androidOTAWIFIOnly = false,
    ErrorHandler? androidOTAErrorHandler,
    String iosAppId = "",
    String iosMt = "8",
  }) {
    var phoneQUpdateUrl =
        "https://phoneq.365power.cn/data/store/lastVersion?platform=android&name=$appName";
    return check(
      androidOTAUpdate: true,
      androidOTAUrl: phoneQUpdateUrl,
      androidOTAUpdateParse: (String? json) async {
        var updateInfo = jsonDecode(json ?? "{}");
        var buildNumber = num.tryParse(await JUtil.buildNumber) ?? 0;
        var versionCode = num.tryParse(updateInfo["versionCode"]) ?? 0;
        var hasUpdate = versionCode > buildNumber;
        return UpdateEntity(
          hasUpdate: hasUpdate,
          versionCode: buildNumber.toInt(),
          versionName: updateInfo["version"],
          updateContent: updateInfo["updateLog"],
          downloadUrl: updateInfo["url"],
        );
      },
      androidOTAThemeColor: androidOTAThemeColor,
      androidOTATopImageRes: androidOTATopImageRes,
      androidOTAWidthRatio: androidOTAWidthRatio,
      androidOTAWIFIOnly: androidOTAWIFIOnly,
      androidOTAErrorHandler: androidOTAErrorHandler,
      iosAppId: iosAppId,
      iosMt: iosMt,
    );
  }

  //执行系统商店更新跳转
  static Future<bool> _doSysLaunch(String uri) async {
    if (!await canLaunch(uri)) return false;
    return await launch(uri);
  }
}
