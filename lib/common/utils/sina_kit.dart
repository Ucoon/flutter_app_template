import 'dart:async';
import 'dart:typed_data';
import 'package:weibo_kit/weibo_kit.dart';

///微博分享工具类
class SinaKit {
  static late final SinaKit _instance = SinaKit._internal();
  factory SinaKit() => _instance;

  SinaKit._internal();

  ///判断微博是否安装
  Future<bool> get isWeiboInstalledKit async {
    return Weibo.instance.isInstalled();
  }

  ///注册QQ AppId
  Future<void> registerApp({
    required String appKey,
    required String? universalLink,
  }) {
    return Weibo.instance.registerApp(
      appKey: appKey,
      universalLink: universalLink,
      scope: <String>[WeiboScope.ALL],
    );
  }

  ///调起微博分享--图片
  Future<void> shareImageToSina({String? text, Uint8List? imageData}) {
    return Weibo.instance.shareImage(
      text: text,
      imageData: imageData,
    );
  }
}
