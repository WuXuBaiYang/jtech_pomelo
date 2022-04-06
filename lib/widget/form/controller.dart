import 'package:flutter/widgets.dart';
import 'package:jtech_pomelo/base/base_notifier.dart';
import 'package:jtech_pomelo/widget/form/form.dart';

//异步提交事件的回调
typedef FormSubmitFuture = Future Function();

/*
* 表单控制器
* @author JTech JH
* @Time 2022/4/6 14:24
*/
class FormController extends MapValueChangeNotifier<String, dynamic> {
  //存储表单key
  final GlobalObjectKey<FormState> _formKey;

  //记录异步操作回调
  final Map<String, FormSubmitFuture> _submitFutureMap = {};

  //数据变化监听注册表
  final Map<String, FormValueChange> _valueChangeMap = {};

  //是否可用（统一控制，优先级低于个体）
  bool _enable;

  //是否只读（统一控制，优先级低于个体）
  bool _readOnly;

  //自动验证模式
  AutovalidateMode _autoValidateMode;

  FormController({
    Map<String, dynamic>? initialData,
    dynamic uniqueKey,
    bool? enable,
    bool? readOnly,
    AutovalidateMode? autoValidateMode,
  })  : _enable = enable ?? true,
        _readOnly = readOnly ?? false,
        _autoValidateMode =
            autoValidateMode ?? AutovalidateMode.onUserInteraction,
        _formKey = GlobalObjectKey(
          uniqueKey ?? DateTime.now().millisecondsSinceEpoch,
        ),
        super(initialData ?? {});

  //获取表单key
  GlobalObjectKey<FormState> get formKey => _formKey;

  //获取可用状态
  bool get enable => _enable;

  //更新可用状态
  void setEnable(bool enable) {
    _enable = enable;
    update(true);
  }

  //获取只读状态
  bool get readOnly => _readOnly;

  //更新只读状态
  void setReadOnly(bool readOnly) {
    _readOnly = readOnly;
    update(true);
  }

  //获取验证状态
  AutovalidateMode get autoValidateMode => _autoValidateMode;

  //更新验证状态
  void setAutoValidateMode(AutovalidateMode autoValidateMode) {
    _autoValidateMode = autoValidateMode;
    update(true);
  }

  //注册数据变化监听
  void registerValueChange(String targetId, FormValueChange valueChange) {
    if (!_valueChangeMap.containsKey(targetId)) {
      _valueChangeMap[targetId] = valueChange;
    }
  }

  //数据变化调用
  void valueChange(String targetId, dynamic value) {
    if (_valueChangeMap.containsKey(targetId)) {
      _valueChangeMap[targetId]?.call(value);
    }
  }

  //设置数据
  void set<V>(String key, V? value) => putValue(key, value);

  //移除数据
  V remove<V>(String key) => removeValue(key);

  //获取表单数据
  V? get<V>(String key, {V? def}) => (value[key] ?? def);

  //更新表单数据
  void updateValue<V>(String key, Function(V? value) onUpdate, {V? def}) {
    var v = get<V>(key, def: def);
    return set(key, onUpdate(v));
  }

  //表单验证
  bool validate() => _formKey.currentState?.validate() ?? false;

  //重置表单
  void reset() => _formKey.currentState?.reset();

  //表单保存
  bool save() {
    if (!validate()) return false;
    _formKey.currentState?.save();
    return true;
  }

  //注册提交回调方法，会在提交的时候处理
  void registerSubmitFuture(String id, FormSubmitFuture submitFuture) {
    _submitFutureMap.putIfAbsent(id, () => submitFuture);
  }

  //表单先验证再保存
  Future<bool> submit() async {
    if (!save()) return false;
    //遍历提交的异步方法并执行
    for (var e in _submitFutureMap.entries) {
      var v = await e.value();
      updateValue(e.key, (_) => v);
    }
    return true;
  }
}
