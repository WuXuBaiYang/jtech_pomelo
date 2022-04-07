import 'package:flutter/material.dart';
import 'package:jtech_pomelo/manage/router.dart';
import 'package:jtech_pomelo/model/select_item.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/form/controller.dart';
import 'package:jtech_pomelo/widget/form/field_item/field_item.dart';
import 'package:jtech_pomelo/widget/form/form.dart';

/*
* 表单项-选择器
* @author JTech JH
* @Time 2022/4/6 15:29
*/
class JFormFieldSelector extends JFormField<String> {
  //选项集合
  final List<SelectItem> items;

  //对齐方式
  final AlignmentGeometry alignment;

  //最大展示行数
  final int maxLines;

  //默认表单项
  const JFormFieldSelector({
    Key? key,
    //基础表单字段
    required String id,
    required FormController controller,
    String? initialValue,
    AutovalidateMode? autoValidateMode,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
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
    required this.items,
    AlignmentGeometry? alignment,
    int? maxLines,
  })  : alignment = alignment ?? AlignmentDirectional.centerEnd,
        maxLines = maxLines ?? 1,
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
          hint: hint ?? "请选择",
          valueChange: valueChange,
          targetId: targetId,
          targetChange: targetChange,
        );

  @override
  State<StatefulWidget> createState() => _JFormFieldSelectorState();
}

/*
* 表单项-选择器-状态
* @author JTech JH
* @Time 2022/4/6 15:33
*/
class _JFormFieldSelectorState
    extends JFormFieldState<String, JFormFieldSelector> {
  //选择值
  late String? _value = initialValue;

  @override
  Widget build(BuildContext context) {
    return buildFieldWithDecorator(
      showHint: false,
      clicked: false,
      builder: (f, valueChange) {
        return DropdownButton<String>(
          value: value,
          underline: const EmptyBox(),
          isExpanded: true,
          isDense: widget.maxLines <= 1,
          hint: enable && !readOnly
              ? Align(
                  alignment: widget.alignment,
                  child: Text(
                    widget.hint ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                )
              : null,
          icon: enable && !readOnly
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.keyboard_arrow_down),
                )
              : const EmptyBox(),
          items: widget.items.map<DropdownMenuItem<String>>((it) {
            return DropdownMenuItem(
              alignment: widget.alignment,
              child: Text(
                it.text,
                maxLines: widget.maxLines,
                textAlign: TextAlign.end,
              ),
              value: it.id,
              enabled: it.enable,
            );
          }).toList(),
          onTap: readOnly ? () => jRouter.pop() : null,
          onChanged: enable
              ? (v) {
                  widget.valueChange?.call(v);
                  valueChange(v);
                  _value = v;
                }
              : null,
        );
      },
    );
  }

  //获取选中值
  String? get value {
    if (null == _value) return _value;
    return widget.items
        .firstWhere((e) => e.id == _value,
            orElse: () => SelectItem(id: _value = null, text: ""))
        .id;
  }
}
