import 'package:flutter/material.dart';
import 'package:jtech_pomelo/pomelo.dart';

void main() {
  runJAppRoot(
    title: "PomeloDemo",
    debug: true,
    homePage: const WelcomePage(),
  );
}

/*
* 欢迎页面
* @author JTech JH
* @Time 2022/4/8 17:31
*/
class WelcomePage extends BaseStatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

/*
* 欢迎页面-状态
* @author JTech JH
* @Time 2022/4/8 17:31
*/
class _WelcomePageState extends BaseState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return JAppPage(
      showAppbar: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flutter_dash_rounded,
              color: JUtil.getAccentColor(context),
              size: 65,
            ),
            const SizedBox(height: 15),
            const Text("Pomelo Demo"),
          ],
        ),
      ),
    );
  }
}
