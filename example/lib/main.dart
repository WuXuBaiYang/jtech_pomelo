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
      body: JListView<Map>(
        enablePullDown: true,
        enablePullUp: true,
        refreshLoad: (pageIndex, pageSize, loadMore) {
          return Future.delayed(const Duration(milliseconds: 2000))
              .then((value) => [
                    {
                      "title": "第一项",
                    },
                    {
                      "title": "第二项",
                    }
                  ]);
        },
        itemBuilder: (BuildContext context, item, int index) {
          return ListTile(
            title: Text(item["title"]),
          );
        },
      ),
    );
  }
}
