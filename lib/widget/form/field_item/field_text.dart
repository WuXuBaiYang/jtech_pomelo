import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jtech_pomelo/widget/form/controller.dart';
import 'package:jtech_pomelo/widget/form/field_item/field_item.dart';
import 'package:jtech_pomelo/widget/form/form.dart';

/*
* 表单项-文本
* @author JTech JH
* @Time 2022/4/6 15:15
*/
class JFormFieldText extends JFormField<String> {
  //文本输入框参数
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool autofocus;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;
  final bool? obscureText;

  //是否启用可视按钮
  final bool showVisible;

  //是否启用内容清除按钮
  final bool showClear;

  //是否展示多行形式
  final bool multiline;

  //默认表单项
  const JFormFieldText({
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
    //自定义字段
    bool? showVisible,
    bool? showClear,
    TextInputAction? textInputAction,
    bool? autofocus,
    bool? obscureText,
    bool? multiline,
    this.minLines,
    this.maxLines,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.onEditingComplete,
    this.onTap,
  })  : showVisible = showVisible ?? false,
        showClear = showClear ?? false,
        textInputAction = textInputAction ?? TextInputAction.next,
        autofocus = autofocus ?? false,
        obscureText = obscureText ?? showVisible,
        multiline = multiline ?? false,
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
          textAlign: textAlign ?? TextAlign.end,
          hint: hint ?? "请输入",
          valueChange: valueChange,
          targetId: targetId,
          targetChange: targetChange,
        );

  @override
  State<StatefulWidget> createState() => _JFormFieldTextState();
}

/*
* 表单项-文本-状态
* @author JTech JH
* @Time 2022/4/6 15:16
*/
class _JFormFieldTextState extends JFormFieldState<String, JFormFieldText> {
  //输入框可视状态
  late bool obscureText = widget.obscureText ?? false;

  //清除按钮是否展示
  bool clear = false;

  @override
  Widget build(BuildContext context) {
    return buildField(
      clicked: false,
      builder: (f, valueChange) {
        if (widget.multiline) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildFixedStyle(),
              _buildTextField(context, f, valueChange),
            ],
          );
        }
        return _buildTextField(context, f, valueChange);
      },
    );
  }

  //构建文本输入框
  Widget _buildTextField(
    BuildContext context,
    FormFieldState<String> f,
    FormValueChange<String> valueChange,
  ) {
    return TextField(
      controller: TextEditingController(
        text: f.value,
      ),
      readOnly: readOnly,
      enabled: enable,
      textAlign: widget.multiline ? TextAlign.start : widget.textAlign,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      obscureText: obscureText,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      onEditingComplete: widget.onEditingComplete,
      onTap: widget.onTap,
      decoration: createDecoration(withFixedStyle: !widget.multiline).copyWith(
        hintText: enable && !readOnly ? widget.hint : null,
        alignLabelWithHint: true,
        errorText: f.errorText,
        enabled: enable,
      ),
      onChanged: (v) {
        valueChange(v);
        if (widget.showClear) {
          if (clear != v.isNotEmpty) {
            setState(() => clear = v.isNotEmpty);
          }
        }
        widget.valueChange?.call(v);
      },
    );
  }

  //必填项校验
  @override
  String? onRequiredValidator(String? v) =>
      (v?.isEmpty ?? true) ? widget.requiredHint : null;

  //结束元素插入
  @override
  List<Widget> insertEndChild() {
    var visibleIcon = obscureText ? Icons.visibility_off : Icons.visibility;
    if (!widget.showClear && !widget.showVisible) {
      return [];
    }
    return [
      //展示清除按钮
      Visibility(
        visible: widget.showClear && clear,
        child: IconButton(
          iconSize: 18,
          focusNode: FocusNode(
            skipTraversal: true,
          ),
          icon: const Icon(Icons.highlight_remove),
          onPressed: () => setState(() {
            widget.controller.clear();
            clear = false;
          }),
        ),
      ),
      //展示可视按钮
      Visibility(
        visible: widget.showVisible,
        child: IconButton(
          focusNode: FocusNode(
            skipTraversal: true,
          ),
          icon: Icon(visibleIcon),
          onPressed: () => setState(() {
            obscureText = !obscureText;
          }),
        ),
      ),
    ];
  }
}
