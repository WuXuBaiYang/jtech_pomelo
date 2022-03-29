import '../base/base_model.dart';

/*
* 请求响应实体
* @author JTech JH
* @Time 2022/3/29 14:35
*/
class ResponseModel<T> extends BaseModel {
  //状态码
  final String code;

  //描述
  final String message;

  //返回值
  final T? data;

  //请求是否成功
  final bool success;

  //构建响应对象
  ResponseModel({
    required this.code,
    required this.message,
    required this.data,
    required this.success,
  });
}
