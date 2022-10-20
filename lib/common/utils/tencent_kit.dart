import 'dart:async';
import 'dart:io';
import 'package:tencent_kit/tencent_kit.dart';

///QQ分享工具类
class TencentKit {
  static late final TencentKit _instance = TencentKit._internal();
  factory TencentKit() => _instance;

  TencentKit._internal();

  ///授权获取设备信息/同意隐私协议
  Future<void> setIsPermissionGranted() {
    return Tencent.instance.setIsPermissionGranted(granted: true);
  }

  ///判断QQ或者TIM是否安装
  Future<bool> get isQQInstalledKit async {
    return await Tencent.instance.isQQInstalled() ||
        await Tencent.instance.isTIMInstalled();
  }

  ///注册QQ AppId
  Future<void> registerApp(String appId) {
    return Tencent.instance.registerApp(appId: appId);
  }

  ///调起QQ分享--图片(只可以分享本地图片)
  Future<void> shareImageToQQ(File file) {
    return Tencent.instance.shareImage(
      scene: TencentScene.SCENE_QQ,
      imageUri: Uri.file(file.path),
    );
  }

  ///调起QQ分享--图文
  Future<void> shareWebpage(
    String urlImage, {
    required String targetUrl,
    required String title,
    String? description,
  }) {
    return Tencent.instance.shareWebpage(
      scene: TencentScene.SCENE_QQ,
      title: title,
      targetUrl: targetUrl,
      imageUri: Uri.parse(urlImage),
      summary: description,
    );
  }
}
