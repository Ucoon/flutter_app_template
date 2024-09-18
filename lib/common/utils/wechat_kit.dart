import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:fluwx/fluwx.dart';

///微信分享、支付等工具类
class WeChatKit {
  ///see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5
  static const int success = 0; //成功
  static const int error = -1; //错误
  static const int cancel = -2; //用户取消

  static late final WeChatKit _instance = WeChatKit._internal();

  factory WeChatKit() => _instance;
  late Fluwx? _fluwx;
  StreamSubscription? _weChatPayListener;

  Function? _weChatResponseCallback;
  Function(WeChatResponse)? responseListener;

  WeChatKit._internal() {
    _fluwx = Fluwx();
  }

  ///[callback] state code errCode
  void setWeChatResponseEventHandler(Function? callback) {
    if (callback == null) return;
    _weChatResponseCallback = callback;
    responseListener = (response) {
      if (response is WeChatPaymentResponse) {
        _weChatResponseCallback!(response.isSuccessful);
      }
    };
    _fluwx?.addSubscriber(responseListener!);
  }

  ///判断微信是否安装
  Future<bool?> get isWeChatInstalledKit async {
    return _fluwx?.isWeChatInstalled;
  }

  ///判断是否注册了监听
  bool get isRegisteredHandler {
    return _weChatPayListener != null;
  }

  ///注册微信AppId
  Future<bool>? registerWeChatApi(
    String appId, {
    String universalLink = '',
  }) {
    return _fluwx?.registerApi(
      appId: appId,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: universalLink,
    );
  }

  ///调起微信支付
  Future<bool>? payByWeChat(dynamic prePayInfo) {
    return _fluwx?.pay(
      which: Payment(
        appId: prePayInfo['appid'],
        partnerId: prePayInfo['partnerid'],
        prepayId: prePayInfo['prepayid'],
        packageValue: prePayInfo['package'],
        nonceStr: prePayInfo['noncestr'],
        timestamp: prePayInfo['timestamp'],
        sign: prePayInfo['sign'],
      ),
    );
  }

  ///调起微信分享--图片
  Future<bool>? shareImageToWeChat(Uint8List originSource) {
    WeChatImage source = WeChatImage.binary(originSource);
    WeChatImage thumbnail = WeChatImage.binary(originSource);
    return _fluwx?.share(WeChatShareImageModel(source, thumbnail: thumbnail));
  }

  ///调起微信分享--网络图片
  Future<bool>? shareNetWorkImageToWeChat(
    String urlImage, {
    String? title,
    String? description,
  }) {
    WeChatImage source = WeChatImage.network(urlImage);
    return _fluwx?.share(WeChatShareImageModel(
      source,
      title: title,
      description: description,
    ));
  }

  ///调起微信分享--url
  Future<bool?> shareUrlToWeChat(
    String url, {
    required Uint8List logo,
    String title = '',
    String description = '',
  }) async {
    WeChatImage thumbnail = WeChatImage.binary(logo);
    return await _fluwx?.share(WeChatShareWebPageModel(
      url,
      title: title,
      description: description,
      thumbnail: thumbnail,
    ));
  }

  ///调起微信小程序
  Future<bool>? launchWeChatMiniProgram(
    String username, {
    String? path,
  }) {
    return _fluwx?.open(target: MiniProgram(username: username));
  }

  ///取消监听
  void cancelWeChatResponseEventHandler() {
    _weChatPayListener?.cancel();
    _weChatResponseCallback = null;
    _weChatPayListener = null;
  }

  ///微信登录
  Future<void> loginByWeChat() async {
    if ((await _fluwx?.isWeChatInstalled) ?? false) {
      _fluwx?.authBy(
        which: NormalAuth(
          scope: "snsapi_userinfo", //scope 应用授权作用域
          state: "yardi_app_wechat",
        ),
      );
    } else {
      if (!Platform.isIOS) return;
      _fluwx?.authBy(
        which: PhoneLogin(
          scope: 'snsapi_userinfo',
          state: 'yardi_app_wechat',
        ),
      );
    }
  }
}
