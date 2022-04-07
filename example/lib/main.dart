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
    return JAppPage(
      title: Text(widget.title),
      body: EmptyBox(),
      // body: JGridView<String>(
      //   itemBuilder: (BuildContext context, item, int index) {
      //     if (index == 0) {
      //       return StaggeredGridTile.fit(
      //         crossAxisCellCount: 2,
      //         child: Container(
      //           color: Colors.green,
      //           child: Text(item),
      //         ),
      //       );
      //     }
      //     return Container(
      //       color: Colors.orange,
      //       child: Text(item),
      //     );
      //   },
      //   crossAxisCount: 3,
      //   controller: GridViewController(
      //     dateList: ["a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e","a", "b", "c", "d", "e",],
      //   ),
      // ),
      // body: JForm(
      //   formBuilder: (context, controller) {
      //     return Column(
      //       children: [
      //         JFormFieldText(
      //           id: "name",
      //           controller: controller,
      //           initialValue: "aaaa",
      //           targetId: "date",
      //           targetChange: (f, value) {
      //             f?.didChange(JDateUtil.formatDate("yyyy-mm-dd", value));
      //           },
      //         ),
      //         JFormFieldDatePicker.dateTime(
      //           id: "date",
      //           controller: controller,
      //           valueChange: (v) {
      //             print(v);
      //           },
      //         ),
      //         JFormFieldSelector(
      //           id: "aa",
      //           controller: controller,
      //           items: [
      //             SelectItem.same(text: "aa"),
      //             SelectItem.same(text: "bb"),
      //           ],
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}

class City extends BaseIndexModel {
  final String name;

  City(this.name) : super.create(tag: name);
}
