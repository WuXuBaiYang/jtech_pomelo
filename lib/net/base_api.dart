import 'dart:async';
import 'package:dio/dio.dart';

import 'api_cancel.dart';
import 'response.dart';
import 'request.dart';

//单次请求的响应回调控制
typedef OnResponseHandle<T> = ResponseModel<T> Function(Response? response);

//授权失效回调（401）
typedef OnAuthFailureCallback = void Function();

/*
* 接口方法基类
* @author JTech JH
* @Time 2022/3/29 15:05
*/
abstract class BaseJAPI {
  //网路请求库
  final Dio _dio;

  BaseJAPI({
    required baseUrl,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    int? maxRedirects,
    OnAuthFailureCallback? onAuthFailureCallback,
    List<Interceptor> interceptors = const [],
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            queryParameters: parameters,
            headers: headers,
            connectTimeout: connectTimeout?.inMilliseconds,
            receiveTimeout: receiveTimeout?.inMilliseconds,
            sendTimeout: sendTimeout?.inMilliseconds,
            maxRedirects: maxRedirects,
          ),
        )..interceptors.addAll([
            InterceptorsWrapper(
              onResponse: (res, handler) {
                //处理401授权失效异常
                if (res.statusCode == 401) {
                  onAuthFailureCallback?.call();
                  return handler.reject(
                    DioError(requestOptions: res.requestOptions),
                  );
                }
                return handler.next(res);
              },
            ),
            //添加自定义拦截器
            ...interceptors
          ]);

  //附件下载
  Future<ResponseModel> download(
    String path, {
    required String savePath,
    RequestModel? request,
    String method = "GET",
    String? cancelKey,
    Options? options,
    bool deleteOnError = true,
    OnResponseHandle? responseHandle,
    ProgressCallback? onReceiveProgress,
    String lengthHeader = Headers.contentLengthHeader,
  }) {
    //默认值
    cancelKey ??= path;
    options ??= Options();
    return handleRequest(
      onRequest: _dio.download(
        path,
        savePath,
        queryParameters: request?.parameters,
        data: request?.data,
        options: options
          ..method ??= method
          ..headers ??= request?.headers,
        cancelToken: jAPICancel.generateToken(cancelKey),
        onReceiveProgress: onReceiveProgress,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      ),
      responseHandle: responseHandle,
    );
  }

  //基本请求方法
  Future<ResponseModel<T>> request<T>(
    String path, {
    RequestModel? request,
    String method = "GET",
    String? cancelKey,
    Options? options,
    OnResponseHandle<T>? responseHandle,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    //默认值
    cancelKey ??= path;
    options ??= Options();
    return handleRequest<T>(
      onRequest: _dio.request(
        path,
        queryParameters: request?.parameters,
        data: request?.data,
        options: options
          ..method ??= method
          ..headers ??= request?.headers,
        cancelToken: jAPICancel.generateToken(cancelKey),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      responseHandle: responseHandle,
    );
  }

  //http-get请求
  Future<ResponseModel<T>> get<T>(
    String path, {
    RequestModel? requestModel,
    String? cancelKey,
    OnResponseHandle<T>? responseHandle,
  }) =>
      request<T>(
        path,
        method: "GET",
        request: requestModel,
        cancelKey: cancelKey,
        responseHandle: responseHandle,
      );

  //http-post请求
  Future<ResponseModel<T>> post<T>(
    String path, {
    RequestModel? requestModel,
    String? cancelKey,
    OnResponseHandle<T>? responseHandle,
  }) =>
      request<T>(
        path,
        method: "POST",
        request: requestModel,
        cancelKey: cancelKey,
        responseHandle: responseHandle,
      );

  //http-put请求
  Future<ResponseModel<T>> put<T>(
    String path, {
    RequestModel? requestModel,
    String? cancelKey,
    OnResponseHandle<T>? responseHandle,
  }) =>
      request<T>(
        path,
        method: "PUT",
        request: requestModel,
        cancelKey: cancelKey,
        responseHandle: responseHandle,
      );

  //http-delete请求
  Future<ResponseModel<T>> delete<T>(
    String path, {
    RequestModel? requestModel,
    String? cancelKey,
    OnResponseHandle<T>? responseHandle,
  }) =>
      request<T>(
        path,
        method: "DELETE",
        request: requestModel,
        cancelKey: cancelKey,
        responseHandle: responseHandle,
      );

  //处理请求响应
  Future<ResponseModel<T>> handleRequest<T>({
    required Future<Response> onRequest,
    OnResponseHandle<T>? responseHandle,
  }) async {
    responseHandle ??= handleResponse<T>;
    Response? response;
    try {
      response = await onRequest;
    } on DioError catch (e) {
      response = e.response;
      rethrow;
    }
    return responseHandle(response);
  }

  //处理请求响应
  ResponseModel<T> handleResponse<T>(Response? response);
}
