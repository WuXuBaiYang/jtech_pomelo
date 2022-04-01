import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/manage/cache.dart';
import 'package:jtech_pomelo/manage/event.dart';
import 'package:jtech_pomelo/manage/notification/notification.dart';
import 'package:jtech_pomelo/manage/router.dart';
import 'package:jtech_pomelo/model/theme_event.dart';
import 'package:jtech_pomelo/util/util.dart';
import 'package:jtech_pomelo/widget/app_root/chinese_cupertino_localizations.dart';

/*
* 应用入口组件
* @author JTech JH
* @Time 2022/4/1 14:09
*/
class JAppRoot extends BaseStatefulWidget {
  //启动首页
  final Widget homePage;

  //应用标题
  final String title;

  //全局样式
  final ThemeData? theme;

  //当前地区
  final Locale? locale;

  //国际化支持
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  //支持的国家地区
  final Iterable<Locale>? supportedLocales;

  //路由方法集合
  final Map<String, WidgetBuilder> routes;

  //路由管理key
  final GlobalKey<NavigatorState>? navigatorKey;

  const JAppRoot({
    Key? key,
    required this.title,
    required this.homePage,
    this.theme,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
    this.navigatorKey,
    Map<String, WidgetBuilder>? routes,
  })  : routes = routes ?? const {},
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JAppRootState();
}

/*
* 应用入口组件-状态
* @author JTech JH
* @Time 2022/4/1 15:08
*/
class _JAppRootState extends BaseState<JAppRoot> {
  //全局样式
  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    //设置初始样式
    _themeData = widget.theme;
    //监听全局样式变化
    jEvent.on<ThemeEvent>().listen((event) {
      setState(() => _themeData = event.themeData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      navigatorKey: widget.navigatorKey,
      theme: _themeData,
      locale: widget.locale,
      //调试模式
      debugShowCheckedModeBanner: debugMode,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate,
        ...?widget.localizationsDelegates,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('zh', 'CN'),
        ...?widget.supportedLocales,
      ],
      routes: widget.routes,
      home: widget.homePage,
    );
  }
}

//应用初始化回调
typedef AppInitialize = Future<void> Function();
//页面加载回调
typedef AppPageLoad = Future<Widget> Function();
/*
* 启动app入口
* @author JTech JH
* @Time 2022/4/1 14:31
*/
Future<void> runJAppRoot({
  required String title,
  required AppPageLoad pageLoad,
  required bool debug,
  AppInitialize? initialize,
  Map<String, WidgetBuilder>? routes,
  ThemeData? theme,
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale>? supportedLocales,
}) async {
  //设定调试模式
  debugMode = debug;
  //初始化默认
  WidgetsFlutterBinding.ensureInitialized();
  await jNotification.init();
  await jCache.init();
  await jEvent.init();
  await jRouter.init();
  //初始化用户自定义方法
  await initialize?.call();
  //运行应用
  var homePage = await pageLoad();
  runApp(JAppRoot(
    title: title,
    homePage: homePage,
    routes: routes ?? {},
    theme: theme,
    locale: locale,
    //在此处默认指定navigateKey
    navigatorKey: jRouter.navigateKey,
    localizationsDelegates: localizationsDelegates,
    supportedLocales: supportedLocales,
  ));
}
