import 'package:flutter/material.dart';
import 'package:jtech_pomelo/util/data_util.dart';
import 'package:jtech_pomelo/widget/form/controller.dart';
import 'package:jtech_pomelo/widget/form/field_item/field_item.dart';
import 'package:jtech_pomelo/widget/form/form.dart';

/*
* 表单项-日期选择器
* @author JTech JH
* @Time 2022/4/6 15:19
*/
class JFormFieldDatePicker extends JFormField<DateTime> {
  //日期展示格式化
  final String pattern;

  //日期输出格式化
  final String outputPattern;

  //起始时间
  final DateTime startDate;

  //结束时间
  final DateTime endDate;

  //选择类型
  final DatePickerType type;

  //日历图标
  final Widget? icon;

  //默认表单项
  JFormFieldDatePicker({
    Key? key,
    //基础表单字段
    required String id,
    required FormController controller,
    DateTime? initialValue,
    AutovalidateMode? autoValidateMode,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
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
    required this.pattern,
    this.icon,
    String? outputPattern,
    DateTime? startDate,
    DateTime? endDate,
    DatePickerType? type,
  })  : outputPattern = outputPattern ?? pattern,
        startDate = startDate ?? DateTime.fromMillisecondsSinceEpoch(0),
        endDate = endDate ?? DateTime.now().add(const Duration(days: 365 * 3)),
        type = type ?? DatePickerType.dateTime,
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

  //日期选择
  JFormFieldDatePicker.date({
    Key? key,
    //基础表单字段
    required String id,
    required FormController controller,
    DateTime? initialValue,
    AutovalidateMode? autoValidateMode,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
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
    this.icon,
    String? outputPattern,
    DateTime? startDate,
    DateTime? endDate,
  })  : outputPattern = outputPattern ?? "yyyy-MM-dd",
        pattern = "yyyy-MM-dd",
        type = DatePickerType.date,
        startDate = startDate ?? DateTime.fromMillisecondsSinceEpoch(0),
        endDate = endDate ?? DateTime.now().add(const Duration(days: 365 * 3)),
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

  //时间选择
  JFormFieldDatePicker.time({
    Key? key,
    //基础表单字段
    required String id,
    required FormController controller,
    DateTime? initialValue,
    AutovalidateMode? autoValidateMode,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
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
    this.icon,
    String? outputPattern,
    DateTime? startDate,
    DateTime? endDate,
  })  : outputPattern = outputPattern ?? "hh:mm",
        pattern = "hh:mm",
        type = DatePickerType.time,
        startDate = startDate ?? DateTime.fromMillisecondsSinceEpoch(0),
        endDate = endDate ?? DateTime.now().add(const Duration(days: 365 * 3)),
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

  //日期时间选择
  JFormFieldDatePicker.dateTime({
    Key? key,
    //基础表单字段
    required String id,
    required FormController controller,
    DateTime? initialValue,
    AutovalidateMode? autoValidateMode,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
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
    this.icon,
    String? outputPattern,
    DateTime? startDate,
    DateTime? endDate,
  })  : outputPattern = outputPattern ?? "yyyy-MM-dd hh:mm",
        pattern = "yyyy-MM-dd hh:mm",
        type = DatePickerType.dateTime,
        startDate = startDate ?? DateTime.fromMillisecondsSinceEpoch(0),
        endDate = endDate ?? DateTime.now().add(const Duration(days: 365 * 3)),
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
  State<StatefulWidget> createState() => _JFormFieldDatePickerState();
}

/*
* 表单项-选择器-状态
* @author wuxubaiyang
* @Time 2022/3/3 9:03
*/
class _JFormFieldDatePickerState
    extends JFormFieldState<DateTime, JFormFieldDatePicker> {
  @override
  Widget build(BuildContext context) {
    return buildFieldWithDecorator(
      builder: (f, valueUpdate) {
        return Row(
          children: [
            Expanded(
              child: Text(
                getSelectDate(f.value),
                textAlign: widget.textAlign,
              ),
            ),
          ],
        );
      },
      onFieldTap: (f, valueChange) async {
        var result = await _showDatePicker(context, f.value);
        if (null != result) valueChange(result);
      },
    );
  }

  //获取选择的日期格式化字符串
  String getSelectDate(DateTime? dateTime) =>
      null != dateTime ? JDateUtil.formatDate(widget.pattern, dateTime) : "";

  //展示日期选择器
  Future<DateTime?> _showDatePicker(
    BuildContext context,
    DateTime? initialDate,
  ) {
    return Future<DateTime?>.sync(() {
      //判断是否要进行日期选择
      if (widget.type == DatePickerType.date ||
          widget.type == DatePickerType.dateTime) {
        return showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: widget.startDate,
          lastDate: widget.endDate,
        );
      }
      return null;
    }).then((date) => _showTimePicker(context, initialDate, date));
  }

  //展示时间选择器
  Future<DateTime?> _showTimePicker(
    BuildContext context,
    DateTime? initialDate,
    DateTime? date,
  ) {
    //判断是否要进行时间选择
    if (widget.type == DatePickerType.time ||
        widget.type == DatePickerType.dateTime) {
      var initialTime = TimeOfDay.fromDateTime(initialDate ?? DateTime.now());
      return showTimePicker(
        context: context,
        initialTime: initialTime,
      ).then<DateTime?>((time) {
        if (null != time) {
          date ??= DateTime.now();
          return DateTime(
            date!.year,
            date!.month,
            date!.day,
            time.hour,
            time.minute,
          );
        }
        return null;
      });
    }
    return Future.value(date);
  }

  @override
  DateTime? get initialValue {
    var v = widget.controller.get<dynamic>(
      widget.id,
      def: widget.initialValue,
    );
    if (v is DateTime) return v;
    if (v is String) return JDateUtil.parseDate(v);
    return widget.initialValue;
  }

  @override
  void onSavedHandle(DateTime? v) {
    super.onSavedHandle(v);
    //更新保存的字段为目标格式化类型
    updateValue((DateTime? value) {
      if (null != value) {
        return JDateUtil.formatDate(widget.outputPattern, value);
      }
    });
  }

  @override
  List<Widget> insertEndChild() {
    return [
      widget.icon ??
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.date_range,
              size: 20,
            ),
          ),
    ];
  }
}

/*
* 日期选择器类型枚举
* @author JTech JH
* @Time 2022/4/6 15:22
*/
enum DatePickerType {
  //(年月日)
  date,
  //(时分秒)
  time,
  //(年月日 时分秒)
  dateTime,
}
