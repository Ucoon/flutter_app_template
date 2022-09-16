import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../global.dart';
import '../http_error.dart';
import '../net_work.dart';

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

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    RequestOptions origin = response.requestOptions;
    if (response.statusCode == HttpStatus.ok) {
      var baseResult = response.data;
      if (baseResult['code'] == HttpError.tokenPastDue) {
        var data = baseResult['data'];
        Global.saveUserToken(data ?? '');
        RequestClient.instance.client!
            .fetch(origin)
            .then(handler.resolve)
            .catchError((e) => handler.reject(e));
      } else {
        handler.next(response);
      }
    } else {
      handler.next(response);
    }
  }
}
