import 'package:flutter/material.dart';
import 'package:jtech_pomelo/widget/form/controller.dart';
import 'package:jtech_pomelo/widget/form/field_item/field_item.dart';
import 'package:jtech_pomelo/widget/form/form.dart';

//表单项构造器
typedef FormFieldCustomBuilder<V> = Widget Function(FormFieldState<V> f,
    FormValueChange<V> valueUpdate, bool enable, bool readOnly);
//必填项回调
typedef RequiredCallback<V> = String? Function(V? v);

/*
* 表单项-自定义
* @author JTech JH
* @Time 2022/4/6 15:18
*/
class JFormFieldCustom<V> extends JFormField<V> {
  //表单项构造器
  final FormFieldCustomBuilder<V> builder;

  //必填项检查
  final RequiredCallback<V>? requiredCallback;

  //焦点变化监听
  final ValueChanged<bool>? onFocusChange;

  //点击事件回调
  final FormFieldTap<V>? onFieldTap;

  //是否使用样式容器
  final bool useDecorator;

  //默认表单项
  const JFormFieldCustom({
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
    required this.builder,
    this.requiredCallback,
    this.onFocusChange,
    this.onFieldTap,
    bool? useDecorator,
  })  : useDecorator = useDecorator ?? true,
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
          hint: hint,
          valueChange: valueChange,
          targetId: targetId,
          targetChange: targetChange,
        );

  @override
  State<StatefulWidget> createState() => _JFormFieldCustomState();
}

/*
* 表单项-文本-状态
* @author JTech JH
* @Time 2022/4/6 15:18
*/
class _JFormFieldCustomState<V>
    extends JFormFieldState<V, JFormFieldCustom<V>> {
  @override
  Widget build(BuildContext context) {
    if (widget.useDecorator) {
      return buildFieldWithDecorator(
        builder: (f, valueUpdate) =>
            widget.builder(f, valueUpdate, enable, readOnly),
        onFocusChange: widget.onFocusChange,
        onFieldTap: widget.onFieldTap,
      );
    }
    return buildField(
      builder: (f, valueUpdate) =>
          widget.builder(f, valueUpdate, enable, readOnly),
      onFocusChange: widget.onFocusChange,
      onFieldTap: widget.onFieldTap,
    );
  }

  //必填项校验
  @override
  String? onRequiredValidator(V? v) => widget.requiredCallback?.call(v);
}
