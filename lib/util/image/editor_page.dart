import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_notifier.dart';
import 'package:jtech_pomelo/base/base_page.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/manage/router.dart';
import 'package:jtech_pomelo/model/menu_item.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/util/sheet_util.dart';
import 'package:jtech_pomelo/util/util.dart';
import 'package:jtech_pomelo/widget/app_page.dart';
import 'package:jtech_pomelo/widget/image/image.dart';

/*
* 图片编辑页
* @author JTech JH
* @Time 2022/4/1 9:49
*/
class ImageEditorPage extends BaseStatefulPage {
  //图片文件对象
  final JFile file;

  //最大缩放比例
  final double maxScale;

  //裁剪比例
  final double initialCropRatio;

  //是否启用比例切换功能
  final bool enableRatioMenu;

  const ImageEditorPage({
    Key? key,
    required this.file,
    this.maxScale = 3.0,
    this.initialCropRatio = -1.0,
    this.enableRatioMenu = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageEditorPageState();
}

/*
* 图片编辑页-状态
* @author JTech JH
* @Time 2022/4/1 9:50
*/
class _ImageEditorPageState extends BaseState<ImageEditorPage> {
  //图片编辑控制key
  final imageKey = GlobalKey<JImageState>();

  //当前裁剪比例
  late ValueChangeNotifier<double> cropRatioNotifier =
      ValueChangeNotifier(widget.initialCropRatio);

  @override
  Widget build(BuildContext context) {
    return JAppPage(
      title: const Text("图片编辑页"),
      actions: [
        IconButton(
          icon: const Icon(Icons.done),
          onPressed: () => _confirm(),
        ),
      ],
      body: ValueListenableBuilder<double>(
        valueListenable: cropRatioNotifier,
        builder: (context, value, child) => JImage.jFile(
          widget.file,
          key: imageKey,
          mode: ExtendedImageMode.editor,
          editorConfig: EditorConfig(
            maxScale: widget.maxScale,
            cropAspectRatio: value < 0 ? null : value,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  //构建底部菜单
  Widget _buildBottomBar() {
    return BottomAppBar(
      color: JUtil.getAccentColor(context),
      child: Row(
        children: [
          Visibility(
            child: _buildActionItem(
              iconData: Icons.crop,
              text: "裁剪",
              onTap: () => _showCropMenu(context).then(
                  (item) => cropRatioNotifier.setValue(item?.value ?? -1)),
            ),
            visible: widget.enableRatioMenu,
          ),
          _buildActionItem(
            iconData: Icons.flip,
            text: "镜像",
            onTap: () => imageKey.currentState?.editorFlip(),
          ),
          _buildActionItem(
            iconData: Icons.rotate_left,
            text: "左转",
            onTap: () => imageKey.currentState?.editorRotateLeft90(),
          ),
          _buildActionItem(
            iconData: Icons.rotate_right,
            text: "右转",
            onTap: () => imageKey.currentState?.editorRotateRight90(),
          ),
          _buildActionItem(
            iconData: Icons.history,
            text: "重置",
            onTap: () => imageKey.currentState?.editorReset(),
          ),
        ],
      ),
    );
  }

  //构建底部操作菜单子项
  Widget _buildActionItem({
    required IconData iconData,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: Colors.white),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  //确认编辑
  Future<void> _confirm() async {
    var result = await imageKey.currentState?.editorCropImage();
    return jRouter.pop<JFile>(result);
  }

  //图片裁剪比例集合
  final Map<String, double> cropMap = {
    "自定义": -1.0,
    "原始": 0.0,
    "1:1": 1.0,
    "3:4": 3.0 / 4.0,
    "4:3": 4.0 / 3.0,
    "9:16": 9.0 / 16,
    "16:9": 16.0 / 9.0,
  };

  //展示裁剪菜单
  Future<JMenuItem?> _showCropMenu(BuildContext context) async {
    return JSheetUtil.showMenu<JMenuItem<double>>(
      context,
      menuItems: cropMap.entries.map<JMenuItem<double>>((e) {
        return JMenuItem(
          text: e.key,
          icon: _buildRatioItem(
            ratio: e.value,
            checked: cropRatioNotifier.value == e.value,
          ),
          value: e.value,
        );
      }).toList(),
    );
  }

  //构建比例展示视图
  Widget _buildRatioItem({
    double baseSize = 45,
    double ratio = 1.0,
    bool checked = false,
  }) {
    if (ratio <= 0) ratio = 1.0;
    return SizedBox(
      width: baseSize,
      child: Center(
        child: Container(
          width: ratio >= 1 ? baseSize : baseSize * ratio,
          height: ratio <= 1 ? baseSize : baseSize / ratio,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: JUtil.getAccentColor(context)),
            borderRadius: BorderRadius.zero,
          ),
          child: Visibility(
            visible: checked,
            child: Icon(
              Icons.check_circle_outline,
              size: 14,
              color: JUtil.getAccentColor(context),
            ),
          ),
        ),
      ),
    );
  }
}
