import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

///Token拦截器
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    ///todo token添加
    Map<String, dynamic> _authorization = {
      'usertoken': '',
    };
    debugPrint('TokenInterceptor.onRequest $_authorization');
    options.headers.addAll(_authorization);
    return handler.next(options);
  }
}
