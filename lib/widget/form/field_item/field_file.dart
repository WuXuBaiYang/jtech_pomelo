import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/util/picker/menu_item.dart';
import 'package:jtech_pomelo/util/util.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/empty_data_box.dart';
import 'package:jtech_pomelo/widget/form/controller.dart';
import 'package:jtech_pomelo/widget/form/field_item/field_item.dart';
import 'package:jtech_pomelo/widget/form/form.dart';
import 'package:jtech_pomelo/widget/future_builder.dart';
import 'package:jtech_pomelo/widget/gridview/accessory/accessory_gridview.dart';
import 'package:jtech_pomelo/widget/gridview/accessory/controller.dart';

//附件上传回调
typedef FormFileUpload<V> = Future<FileUploadResult<V>> Function(
    List<JFile> files, V? value);

//附件加载
typedef FormFileLoad<V> = Future<List<JFile>> Function(V? value);

/*
* 表单项-附件选择器
* @author JTech JH
* @Time 2022/4/6 15:23
*/
class JFormFieldFile<V> extends JFormField<V> {
  //附件上传回调
  final FormFileUpload<V> fileUpload;

  //附件加载
  final FormFileLoad<V> fileLoad;

  //附件选择菜单集合
  final List<PickerMenuItem> pickerItems;

  //是否直接展开展示
  final bool showExpend;

  //最大选择数
  final int maxCount;

  //横向附件数量
  final int crossAxisCount;

  //附件项点击事件
  final ItemTap<JFile>? itemTap;

  //附件项预览自定义
  final AccessoryPreview? accessoryPreview;

  //附件项占位图表
  final Map<RegExp, Widget>? itemPlaceholderMap;

  //默认表单项
  const JFormFieldFile({
    Key? key,
    //基础表单字段
    required String id,
    required FormController controller,
    V? initialValue,
    AutovalidateMode? autoValidateMode,
    FormFieldSetter<V>? onSaved,
    FormFieldValidator<V>? validator,
    bool? readOnly,
    bool? enable,
    bool? required,
    bool? showRequired,
    String? requiredHint,
    InputDecoration? decoration,
    Widget? startChild,
    String? startText,
    TextStyle? startTextStyle,
    Widget? endChild,
    bool? showArrow,
    EdgeInsetsGeometry? padding,
    TextAlign? textAlign,
    String? hint,
    FormValueChange? valueChange,
    String? targetId,
    FormTargetChange? targetChange,
    //自定义参数
    required this.pickerItems,
    required this.fileUpload,
    required this.fileLoad,
    this.itemTap,
    this.accessoryPreview,
    this.itemPlaceholderMap,
    String? errorText,
    bool? showExpend,
    int? maxCount,
    int? crossAxisCount,
  })  : showExpend = showExpend ?? true,
        maxCount = maxCount ?? 9,
        crossAxisCount = crossAxisCount ?? 4,
        super(
          key: key,
          id: id,
          controller: controller,
          readOnly: readOnly,
          enable: enable,
          initialValue: initialValue,
          autoValidateMode: autoValidateMode,
          onSaved: onSaved,
          validator: validator,
          required: required,
          showRequired: showRequired,
          requiredHint: requiredHint,
          decoration: decoration,
          startChild: startChild,
          startText: startText,
          startTextStyle: startTextStyle,
          endChild: endChild,
          showArrow: showArrow,
          padding: padding,
          textAlign: textAlign,
          hint: hint ?? "查看附件",
          valueChange: valueChange,
          targetId: targetId,
          targetChange: targetChange,
        );

  @override
  State<StatefulWidget> createState() => _JFormFieldFileState();
}

/*
* 表单项-附件选择器-状态
* @author JTech JH
* @Time 2022/4/6 15:23
*/
class _JFormFieldFileState<V> extends JFormFieldState<V, JFormFieldFile> {
  @override
  Widget build(BuildContext context) {
    return buildField(
      clicked: !widget.showExpend,
      builder: (f, valueChange) {
        registerFileUpload(f, valueChange);
        return InputDecorator(
          textAlign: widget.textAlign,
          isFocused: focusNode.hasFocus,
          isEmpty: null == f.value,
          decoration: createDecoration(withFixedStyle: false).copyWith(
            errorText: f.errorText,
            enabled: enable,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildFixedStyle(),
              widget.showExpend ? _buildFileGrid(context, f) : const EmptyBox(),
            ],
          ),
        );
      },
      onFieldTap: (f, valueChange) => _showFileGridSheet(context, f),
    );
  }

  //注册异步提交方法
  void registerFileUpload(FormFieldState<V> f, FormValueChange<V> valueChange) {
    return registerSubmitFuture(() async {
      var result = await widget.fileUpload(
        fileController?.value ?? [],
        f.value,
      );
      fileController?.setValue(result.files);
      valueChange(result.value);
      return result.value;
    });
  }

  //展示附件表格弹窗
  Future _showFileGridSheet(BuildContext context, FormFieldState<V> f) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                const CloseButton(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(widget.hint ?? ""),
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildFileGrid(context, f),
          ],
        );
      },
    );
  }

  //附件控制器
  AccessoryGridViewController? fileController;

  //构建附件表格
  Widget _buildFileGrid(BuildContext context, FormFieldState<V> f) {
    return JFutureBuilder<List<JFile>>(
      future: () async {
        if (null == fileController) {
          var fileList = await widget.fileLoad(f.value);
          fileController = AccessoryGridViewController(dataList: fileList);
        }
        return fileController?.value ?? [];
      },
      builder: (_, snap) {
        var canModify = enable && !readOnly;
        return EmptyDataBox(
          isEmpty: !canModify && (snap.data?.isEmpty ?? true),
          child: JAccessoryGridView(
            pickerMenuItems: widget.pickerItems,
            controller: fileController,
            maxCount: widget.maxCount,
            crossAxisCount: widget.crossAxisCount,
            modify: canModify,
            itemPlaceholderMap: widget.itemPlaceholderMap,
            accessoryPreview: widget.accessoryPreview,
            canScroll: false,
            itemTap: widget.itemTap,
          ),
        );
      },
    );
  }

  @override
  List<Widget> insertEndChild() {
    String? hint;
    if (enable && !widget.showExpend) {
      hint = widget.hint;
    }
    var showHint = null != initialValue && "$initialValue".isNotEmpty;
    return [
      Visibility(
        visible: showHint,
        child: Text(
          hint ?? "",
          style: TextStyle(color: JUtil.getAccentColor(context)),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Icon(Icons.attach_file_outlined, size: 18),
      ),
    ];
  }

  @override
  String? onRequiredValidator(V? v) =>
      (null != v || (fileController?.isNotEmpty ?? false))
          ? null
          : widget.requiredHint;
}

/*
* 附件上传返回值
* @author JTech JH
* @Time 2022/3/10 9:47
*/
class FileUploadResult<V> {
  //参数值
  final V? value;

  //上传成功的附件集合
  final List<JFile> files;

  FileUploadResult({
    required this.value,
    required this.files,
  });
}
