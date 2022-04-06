import 'package:flutter/material.dart';
import 'package:jtech_pomelo/pomelo.dart';

void main() {
  runJAppRoot(
    title: "pomelo demo",
    pageLoad: () async {
      return const MyHomePage(title: "pomelo demo");
    },
    debug: false,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return JAppPage(
    return JAppPage(
      title: Text(widget.title),
      body: Center(
        child: JBanner(
          showTitle: true,
          items: [
            BannerItem(
              enable: false,
              child: JImage.net(
                "http://static.runoob.com/images/demo/demo2"
                ".jpg",
                fit: BoxFit.cover,
              ),
              text: "项目一",
            ),
            BannerItem(
              child: JImage.net(
                "https://img95.699pic.com/photo/40094/7630.jpg_wh300.jpg",
                fit: BoxFit.cover,
              ),
              text: "项目二",
            ),
            BannerItem(
              child: JImage.net(
                "https://pic2.zhimg"
                ".com/v2-4bba972a094eb1bdc8cbbc55e2bd4ddf_1440w.jpg?source=172ae18b",
                fit: BoxFit.cover,
              ),
              text: "项目三",
            ),
          ],
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {},
        //       child: const Text("测试"),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
