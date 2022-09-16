import 'dart:io';
import 'package:dio/dio.dart';
import 'entity/base_resp_entity.dart';
import 'http_error.dart';
import 'interceptor/local_log_interceptor.dart';
import 'interceptor/token_interceptor.dart';
import 'net_cancel_scope.dart';
import 'net_exception.dart';
import '../common/values/values.dart';

///http请求成功回调
typedef HttpSuccessCallback<T> = void Function(T result);

///失败回调
typedef HttpFailureCallback = void Function(HttpError err);

class RequestClient {
  static const int httpSucceed = 200;
  static final RequestClient instance = RequestClient._internal();

  factory RequestClient() => instance;
  Dio? client;
  CancelScope? cancelScope;

  RequestClient._internal() {
    if (client == null) {
      // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
      BaseOptions options = BaseOptions(
        // 请求基地址,可以包含子路径
        baseUrl: serverApiUrl,

        // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: 10000,

        // 响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: 10000,

        /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
        /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
        /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
        /// 就会自动编码请求体.
        contentType: 'application/json; charset=utf-8',

        /// [responseType] 表示期望以那种格式(方式)接受响应数据。
        /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
        ///
        /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
        /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
        ///
        /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
        responseType: ResponseType.json,
      );
      client = Dio(options);
      client!.interceptors.add(
          LocalLogInterceptor(requestBody: true, responseBody: true)); //开启请求日志
      client!.interceptors.add(TokenInterceptor());
    }
  }

  Future<BaseRespEntity<T>> get<T>(String url,
      {Map<String, dynamic>? params, Options? options}) {
    return _request<T>(
      url,
      queryParameters: params,
      method: 'get',
      options: options,
    );
  }

  Future<BaseRespEntity<T>> post<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) {
    return _request<T>(url,
        data: data ?? {},
        queryParameters: queryParams,
        method: 'post',
        options: options);
  }

  Future<BaseRespEntity<T>> postForm<T>(
    String url, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) {
    return _request<T>(url,
        data: FormData.fromMap(params!),
        queryParameters: queryParams,
        formDataParameters: params,
        method: 'post',
        options: options);
  }

  Future<BaseRespEntity<T>> delete<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) {
    return _request<T>(url,
        data: data ?? {},
        queryParameters: queryParams,
        method: 'delete',
        options: options);
  }

  Future<BaseRespEntity<T>> _request<T>(String requestUrl,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? header,
      Map<String, dynamic>? formDataParameters,
      String? method,
      Options? options}) async {
    //设置默认值
    queryParameters = queryParameters ?? {};
    options = options ??
        Options(
          method: method,
        );
    CancelToken cancelToken = cancelScope!.get();
    Response response = await client!.request(requestUrl,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);

    if (response.statusCode == HttpStatus.ok) {
      var baseResult = response.data;
      if (baseResult['code'] == httpSucceed || baseResult['errorCode'] == "0") {
        var data = baseResult['data'];
        if (data != null) {
          try {
            BaseRespEntity<T> baseResEntity = BaseRespEntity()
              ..data = data
              ..code = baseResult['code'] ?? int.parse(baseResult['errorCode'])
              ..success = baseResult['success'];
            return Future.value(baseResEntity);
          } catch (e) {
            throw (ResponseException(
                code: baseResult['code'], msg: e.toString()));
          }
        } else {
          BaseRespEntity<T> baseResEntity = BaseRespEntity()
            ..code = baseResult['code']
            ..success = baseResult['success'];
          return Future.value(baseResEntity);
        }
      } else {
        throw (ResponseException(
            code: baseResult['code'], msg: baseResult['msg']));
      }
    } else {
      throw (DioError(requestOptions: RequestOptions(path: requestUrl)));
    }
  }
}
