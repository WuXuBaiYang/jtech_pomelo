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
      body: JForm(
        formBuilder: (context, controller) {
          return Column(
            children: [
              JFormFieldText(
                id: "name",
                controller: controller,
                initialValue: "aaaa",
                targetId: "date",
                targetChange: (f, value) {
                  f?.didChange(JDateUtil.formatDate("yyyy-mm-dd", value));
                },
              ),
              JFormFieldDatePicker.dateTime(
                id: "date",
                controller: controller,
                valueChange: (v) {
                  print(v);
                },
              ),
              JFormFieldSelector(
                id: "aa",
                controller: controller,
                items: [
                  SelectItem.same(text: "aa"),
                  SelectItem.same(text: "bb"),
                ],
              ),
              JFormFieldFile(
                id: "gg",
                controller: controller,
                pickerItems: [
                  PickerMenuItem.image(text: "aaa"),
                  PickerMenuItem.imageTake(text: "bbb"),
                ],
                fileUpload: (List<JFile> files, value) async {
                  return FileUploadResult(value: value, files: files);
                },
                fileLoad: (Object? value) async {
                  return [];
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class City extends BaseIndexModel {
  final String name;

  City(this.name) : super.create(tag: name);
}
