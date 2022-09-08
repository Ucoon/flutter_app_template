import 'package:dio/dio.dart';
import '../global.dart';
import '../widget/widget.dart';
import 'net_exception.dart';

class HttpError {
  ///HTTP 状态码
  static const int unAuthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int requestTimeout = 408;
  static const int internalServerError = 500;
  static const int badGateWay = 502;
  static const int serviceUnAvailable = 503;
  static const int gateWayTimeout = 504;

  ///token 无效
  static const int tokenInValid = 20004;

  ///token 过期
  static const int tokenPastDue = 20007;

  ///未知错误
  static const String unknown = "UNKNOWN";

  ///解析错误
  static const String parseError = "PARSE_ERROR";

  ///网络错误
  static const String networkError = "NETWORK_ERROR";

  ///协议错误
  static const String httpError = "HTTP_ERROR";

  ///证书错误
  static const String sslError = "SSL_ERROR";

  ///连接超时
  static const String connectTimeout = "CONNECT_TIMEOUT";

  ///响应超时
  static const String receiveTimeout = "RECEIVE_TIMEOUT";

  ///发送超时
  static const String sendTimeout = "SEND_TIMEOUT";

  ///网络请求取消
  static const String cancel = "CANCEL";

  // static const String netException = '无网络，请检查网络';
  static const String netException = 'NETWORK ERROR';

  ///定义调用原生aop代码
  static const String androidAop = "habit";
  static const String androidAopLoginMethod = "go2Login";

  String code = '';

  String message = '';

  HttpError(this.code, this.message);

  HttpError.checkNetError(dynamic error) {
    if (error is DioError) {
      message = error.message;
      switch (error.type) {
        case DioErrorType.connectTimeout:
          code = connectTimeout;
          message = netException;
          break;
        case DioErrorType.receiveTimeout:
          code = receiveTimeout;
          message = netException;
          break;
        case DioErrorType.sendTimeout:
          code = sendTimeout;
          message = netException;
          break;
        case DioErrorType.response:
          var statusCode = error.response?.statusCode;
          code = statusCode.toString();
          message = netException;
          break;
        case DioErrorType.cancel:
          code = cancel;
          break;
        case DioErrorType.other:
          code = unknown;
          message = netException;
          break;
      }
    } else if (error is ResponseException) {
      code = error.code.toString();
      message = error.msg ?? '';
    } else {
      code = unknown;
      message = error.toString();
    }
  }

  Future<void> handleError() async {
    if (code == tokenInValid.toString()) {
      toastInfo(msg: message);
      Global.logout();
    } else if (code == tokenPastDue.toString()) {
    } else {
      // toastInfo(msg: message);
    }
  }

  @override
  String toString() {
    return 'HttpError{code: $code, message: $message}';
  }
}
