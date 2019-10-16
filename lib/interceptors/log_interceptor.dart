import 'package:dio/dio.dart';
import 'dart:convert';
class LogsInterceptors extends InterceptorsWrapper{
  @override
  onRequest(RequestOptions options) {
    print("请求url:${options.path}");
    print("请求头："+ options.headers.toString());
    if(options.data != null){
      print("请求参数"+options.data.toString());
    }
    return options;
  }
  @override
  onResponse(Response response) {
    if(response != null){
      print("返回参数:${response.toString()}");
    }
    return response;
  }
  @override
  onError(DioError err) {
    print("请求异常："+err.toString());
//    print("请求异常信息："+err.response?.toString() ?? "");
    return err;
  }
}