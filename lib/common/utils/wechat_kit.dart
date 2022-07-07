import 'dart:async';
import 'dart:io';
import 'package:fluwx/fluwx.dart' as fluwx;

///微信分享、支付等工具类
class WeChatKit {
  ///see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5
  static const int success = 0; //成功
  static const int error = -1; //错误
  static const int cancel = -2; //用户取消

  static late final WeChatKit _instance = WeChatKit._internal();
  factory WeChatKit() => _instance;

  StreamSubscription? _weChatPayListener;

  Function? _weChatResponseCallback;

  WeChatKit._internal();

  void setWeChatResponseEventHandler(Function? callback) {
    if (callback == null) return;
    _weChatResponseCallback = callback;
    _weChatPayListener ??= fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((event) {
      _weChatResponseCallback!(event);
    });
  }

  ///判断微信是否安装
  Future<bool> get isWeChatInstalledKit async {
    return fluwx.isWeChatInstalled;
  }

  ///注册微信AppId
  Future<void> registerWeChatApi(
    String appId, {
    String universalLink = '',
  }) {
    return fluwx.registerWxApi(
      appId: appId,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: universalLink,
    );
  }

  ///调起微信支付
  Future<bool> payByWeChat(dynamic prePayInfo) {
    return fluwx.payWithWeChat(
      appId: prePayInfo['appid'],
      partnerId: prePayInfo['partnerid'],
      prepayId: prePayInfo['prepayid'],
      packageValue: prePayInfo['package'],
      nonceStr: prePayInfo['noncestr'],
      timeStamp: prePayInfo['timestamp'],
      sign: prePayInfo['sign'],
    );
  }

  ///调起微信分享--图片
  void shareImageToWeChat(
      fluwx.WeChatImage source, fluwx.WeChatImage thumbnail) {
    fluwx.shareToWeChat(
        fluwx.WeChatShareImageModel(source, thumbnail: thumbnail));
  }

  ///调起微信小程序
  Future<bool> launchWeChatMiniProgram(
    String username, {
    String? path,
  }) {
    return fluwx.launchWeChatMiniProgram(username: username);
  }

  ///取消监听
  void cancelWeChatResponseEventHandler() {
    _weChatPayListener?.cancel();
    _weChatResponseCallback = null;
    _weChatPayListener = null;
  }

  ///微信登录
  Future<void> loginByWeChat() async {
    if (await fluwx.isWeChatInstalled) {
      fluwx.sendWeChatAuth(
        scope: "snsapi_userinfo", //scope 应用授权作用域
        state: "yardi_app_wechat",
      );
    } else {
      if (!Platform.isIOS) return;
      fluwx.authWeChatByPhoneLogin(
          scope: 'snsapi_userinfo', state: 'yardi_app_wechat');
    }
  }
}
