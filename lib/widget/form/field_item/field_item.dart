import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';
import 'package:jtech_pomelo/widget/form/controller.dart';
import 'package:jtech_pomelo/widget/form/form.dart';

//表单子项点击事件
typedef FormFieldTap<V> = void Function(
    FormFieldState<V> f, FormValueChange<V> valueUpdate);

//表单子项内容构建
typedef FormFieldBuilder<V> = Widget Function(
    FormFieldState<V> f, FormValueChange<V> valueUpdate);

//表单注册目标值变化监听
typedef FormTargetChange<V> = void Function(
    FormFieldState<V>? f, dynamic targetValue);

/*
* 表单子项基类
* @author JTech JH
* @Time 2022/4/6 15:05
*/
abstract class JFormField<V> extends BaseStatefulWidget {
  //表单子项id
  final String id;

  //表单控制器
  final FormController controller;

  final bool? readOnly;

  //是否可用
  final bool? enable;

  //自动验证模式
  final AutovalidateMode? autoValidateMode;

  //是否必填
  final bool required;

  //必填提示
  final String requiredHint;

  //初始化数据
  final V? initialValue;

  //保存操作
  final FormFieldSetter<V>? onSaved;

  //验证操作
  final FormFieldValidator<V>? validator;

  //表单项样式控制
  final InputDecoration? decoration;

  //判断是否展示必填标记
  final bool showRequired;

  //开始部分元素
  final Widget? startChild;

  //开始部分文本
  final String? startText;

  //开始部分文本样式
  final TextStyle? startTextStyle;

  //结束部分元素
  final Widget? endChild;

  //是否展示箭头
  final bool showArrow;

  //内间距
  final EdgeInsetsGeometry padding;

  //文本对齐
  final TextAlign textAlign;

  //默认提示文本
  final String? hint;

  //数据变化监听
  final FormValueChange<V>? valueChange;

  //要注册的目标id
  final String? targetId;

  //目标值变化的回调
  final FormTargetChange<V>? targetChange;

  const JFormField({
    Key? key,
    required this.id,
    required this.controller,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.decoration,
    this.startChild,
    this.startText,
    this.startTextStyle,
    this.endChild,
    this.autoValidateMode,
    this.enable,
    this.readOnly,
    this.hint,
    this.valueChange,
    this.targetId,
    this.targetChange,
    bool? showArrow,
    bool? showRequired,
    bool? required,
    String? requiredHint,
    EdgeInsetsGeometry? padding,
    TextAlign? textAlign,
  })  : required = required ?? false,
        showRequired = showRequired ?? true,
        requiredHint = requiredHint ?? "不能为空",
        showArrow = showArrow ?? false,
        padding = padding ?? const EdgeInsets.only(bottom: 8),
        textAlign = textAlign ?? TextAlign.end,
        super(key: key);

  //执行校验
  String? doValidator(V? v) => validator?.call(v);

  //执行保存操作
  void doSaved(V? v) => onSaved?.call(v);
}

/*
* 表单子项基类-状态
* @author JTech JH
* @Time 2022/4/6 15:05
*/
abstract class JFormFieldState<V, T extends JFormField> extends BaseState<T> {
  //判断是否可用,以当前对象为优先
  bool get enable => widget.enable ?? widget.controller.enable;

  //判断是否为只读,以当前对象为优先
  bool get readOnly => widget.readOnly ?? widget.controller.readOnly;

  //获取自动验证模式
  AutovalidateMode get autoValidateMode =>
      widget.autoValidateMode ?? widget.controller.autoValidateMode;

  //获取当前值
  V? get initialValue =>
      widget.controller.get<V>(widget.id, def: widget.initialValue);

  //表单项key持有
  final fieldKey = GlobalKey<FormFieldState<V>>();

  //焦点控制器
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //判断是否需要注册监听
    if (null != widget.targetId && null != widget.targetChange) {
      widget.controller.registerValueChange(widget.targetId!, (value) {
        widget.targetChange!(fieldKey.currentState, value);
      });
    }
  }

  //构造表单子项
  Widget buildField({
    required FormFieldBuilder<V> builder,
    ValueChanged<bool>? onFocusChange,
    FormFieldTap<V>? onFieldTap,
    bool clicked = true,
  }) {
    return Padding(
      padding: widget.padding,
      child: FormField<V>(
        key: fieldKey,
        enabled: enable,
        initialValue: initialValue,
        autovalidateMode: autoValidateMode,
        builder: (f) {
          return InkWell(
            focusNode: focusNode,
            onFocusChange: (v) => setState(() => onFocusChange?.call(v)),
            child: builder(f, (v) => _onValueChange(f, v)),
            onTap: clicked && enable
                ? () {
                    focusNode.requestFocus();
                    onFieldTap?.call(f, (v) => _onValueChange(f, v));
                  }
                : null,
          );
        },
        validator: onValidatorHandle,
        onSaved: onSavedHandle,
      ),
    );
  }

  //数值变化处理
  void _onValueChange(FormFieldState<V> f, V? value) {
    widget.controller.valueChange(widget.id, value);
    widget.valueChange?.call(value);
    f.didChange(value);
  }

  //构建表单子项并携带样式容器
  Widget buildFieldWithDecorator({
    required FormFieldBuilder<V> builder,
    ValueChanged<bool>? onFocusChange,
    InputDecoration? decoration,
    FormFieldTap<V>? onFieldTap,
    bool showHint = true,
    bool showError = true,
    bool clicked = true,
    bool withFixedStyle = true,
  }) {
    decoration ??= createDecoration(withFixedStyle: withFixedStyle);
    return buildField(
      onFocusChange: onFocusChange,
      onFieldTap: onFieldTap,
      clicked: clicked,
      builder: (f, valueUpdate) => InputDecorator(
        textAlign: widget.textAlign,
        isFocused: focusNode.hasFocus,
        isEmpty: null == f.value,
        decoration: decoration!.copyWith(
          hintText: showHint ? widget.hint : null,
          errorText: showError ? f.errorText : null,
          enabled: enable,
        ),
        child: builder(f, valueUpdate),
      ),
    );
  }

  //数据校验处理
  String? onValidatorHandle(V? v) {
    String? err;
    if (widget.required) {
      err = onRequiredValidator(v);
    }
    return err ?? widget.doValidator(v);
  }

  //获取容器样式
  InputDecoration createDecoration({bool withFixedStyle = true}) {
    var decoration = widget.decoration ?? const InputDecoration();
    decoration = decoration.copyWith(
      isCollapsed: true,
      contentPadding: const EdgeInsets.all(15),
      labelStyle: const TextStyle(
        fontSize: 14,
      ),
    );
    if (!withFixedStyle) decoration;
    return decoration.copyWith(
      prefixIcon: buildStartChild(),
      suffixIcon: buildEndChild(),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 0,
      ),
    );
  }

  //构建开始部分元素
  Widget? buildStartChild() {
    String? requiredTag = (widget.required && widget.showRequired) ? "*" : null;
    var insertChildren = insertStartChild();
    if (insertChildren.isEmpty &&
        null == widget.startChild &&
        null == widget.startText &&
        null == requiredTag) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: requiredTag,
                style: const TextStyle(color: Colors.red),
              ),
              TextSpan(
                text: widget.startText,
                style: widget.startTextStyle,
              ),
            ],
          ),
        ),
        widget.startChild ?? const EmptyBox(),
        ...insertChildren,
      ],
    );
  }

  //插入开始部分元素
  List<Widget> insertStartChild() => [];

  //构建结束部分元素
  Widget? buildEndChild() {
    var insertChildren = insertEndChild();
    if (insertChildren.isEmpty &&
        null == widget.endChild &&
        !widget.showArrow) {
      return null;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...insertChildren,
        widget.endChild ?? const EmptyBox(),
        Visibility(
          child: const Icon(Icons.keyboard_arrow_right),
          visible: widget.showArrow,
        ),
      ],
    );
  }

  //插入结束部分元素
  List<Widget> insertEndChild() => [];

  //构建表单固定样式
  Widget buildFixedStyle() {
    var startChild = buildStartChild();
    var endChild = buildEndChild();
    return Visibility(
      visible: null != startChild || null != endChild,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            startChild ?? const EmptyBox(),
            const Expanded(child: EmptyBox()),
            endChild ?? const EmptyBox(),
          ],
        ),
      ),
    );
  }

  //必填校验
  String? onRequiredValidator(V? v) => null == v ? widget.requiredHint : null;

  //数据保存处理
  void onSavedHandle(V? v) {
    widget.controller.set(widget.id, v);
    return widget.doSaved(v);
  }

  //注册异步提交方法
  void registerSubmitFuture(FormSubmitFuture submitFuture) =>
      widget.controller.registerSubmitFuture(widget.id, submitFuture);

  //更新字段
  void updateValue(Function(V? value) onUpdate, {V? def}) =>
      widget.controller.updateValue<V>(widget.id, onUpdate, def: def);

  //存储字段
  void setValue(String key, V? value) => widget.controller.set<V>(key, value);

  //获取字段
  V? getValue(String key, {V? def}) => widget.controller.get<V>(key, def: def);
}
