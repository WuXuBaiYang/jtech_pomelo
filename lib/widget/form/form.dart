import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/form/controller.dart';

//表单内容构建器
typedef FormBuilder = Widget Function(
    BuildContext context, FormController controller);

//后退回调
typedef FormWillPop = Future<bool> Function(bool edited);

//表单项值变化回调
typedef FormValueChange<V> = void Function(V? newValue);

/*
* 表单组件
* @author JTech JH
* @Time 2022/4/6 15:02
*/
class JForm extends BaseStatefulWidget {
  //表单控制器
  final FormController? controller;

  //表单子项构建器
  final FormBuilder formBuilder;

  //后退拦截
  final FormWillPop? formWillPop;

  //表单变动监听
  final VoidCallback? onChanged;

  //内间距
  final EdgeInsetsGeometry? padding;

  const JForm({
    Key? key,
    required this.formBuilder,
    this.formWillPop,
    this.onChanged,
    this.padding,
    this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JFormState();
}

/*
* 表单组件-状态
* @author JTech JH
* @Time 2022/4/6 15:02
*/
class _JFormState extends BaseState<JForm> {
  //记录编辑状态
  bool formEdited = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: widget.padding,
      child: Form(
        key: controller.formKey,
        onWillPop: () {
          if (null != widget.formWillPop) {
            return widget.formWillPop!(formEdited);
          }
          return Future.value(true);
        },
        onChanged: () {
          formEdited = true;
          widget.onChanged?.call();
        },
        child: widget.formBuilder(context, controller),
      ),
    );
  }

  //缓存控制器对象
  FormController? _controller;

  //获取控制器对象
  FormController get controller =>
      widget.controller ?? (_controller ??= FormController());
}
