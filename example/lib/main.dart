import 'package:flutter/material.dart';
import 'package:jtech_pomelo/pomelo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: jRouter.navigateKey,
      title: 'JTech Pomelo Example',
      home: const MyHomePage(title: 'JTech Pomelo Example'),
    );
  }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("测试"),
          onPressed: () {
            jRouter.push(
              (context, animation, secondaryAnimation) {
                return PreviewPage(
                  items: [
                    PreviewOptionItem(
                        type: PreviewType.image,
                        uri:
                            "https://tse1-mm.cn.bing.net/th/id/R-C.4d9cd2e53dddfc238a06e750b73cd023?rik=MsMCKPGumufOyQ&riu=http%3a%2f%2fwww.desktx.com%2fd%2ffile%2fwallpaper%2fscenery%2f20170209%2fc2accfe637f86fb6f11949cb8651a09b.jpg&ehk=ia2TVXcow6ygWUVZ1yod5xH4aGd8565SYn6CRpxkNoo%3d&risl=&pid=ImgRaw&r=0"),
                    PreviewOptionItem(
                        type: PreviewType.video,
                        uri:
                            "https://klxxcdn.oss-cn-hangzhou.aliyuncs.com/histudy/hrm/media/bg1.mp4"),
                    PreviewOptionItem(
                        type: PreviewType.other,
                        uri:
                            "https://img.mianfeiwendang.com/pic/65133e4129b6446aa22c9f9f/1-810-jpg_6-1080-0-0-1080.jpg"),
                  ],
                );
              },
              opaque: false,
              barrierColor: Colors.black87,
            );
          },
        ),
      ),
    );
  }
}
