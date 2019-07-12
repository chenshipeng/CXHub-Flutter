import 'package:dio/dio.dart';
class HeaderInterceptors extends InterceptorsWrapper{
  @override
  onRequest(RequestOptions options) {
    options.connectTimeout = 15000;
    return options;
  }
}