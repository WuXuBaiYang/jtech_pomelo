import 'package:flutter/material.dart';
import 'package:jtech_pomelo/pomelo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'JTech Pomelo Example',
      home: MyHomePage(title: 'JTech Pomelo Example'),
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
            PickerUtil.pick(
              context,
              menuItems: [
                PickerMenuItem.image(text: "图片"),
                PickerMenuItem.imageTake(text: "拍摄", frontCamera: true),
                PickerMenuItem.video(text: "视频"),
                PickerMenuItem.videoRecord(
                    text: "录制", maxDuration: Duration(seconds: 10)),
                PickerMenuItem.custom(text: "自定义", allowedExtensions: ["pdf"]),
              ],
            ).then((value) {
              print("");
            });
          },
        ),
      ),
    );
  }
}
