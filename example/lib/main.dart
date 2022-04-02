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

  var controller = NavigationController(items: [
    NavigationItem.text(
        title: "页面一",
        activeTitle: "aaaa",
        icon: Icon(Icons.home),
        page: Center(
          child: Text("页面一"),
        )),
    NavigationItem.text(
        title: "页面二",
        activeTitle: "aaaa",
        icon: Icon(Icons.my_library_add_outlined),
        page: Center(
          child: Text("页面二"),
        )),
  ]);

  @override
  Widget build(BuildContext context) {
    return JAppPage.bottomBar(
      controller: controller,
      title: Text(widget.title),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       updateGlobalTheme(dark ? ThemeData.light() : ThemeData.dark());
      //       dark = !dark;
      //     },
      //     child: const Text("测试"),
      //   ),
      // ),
    );
  }
}
