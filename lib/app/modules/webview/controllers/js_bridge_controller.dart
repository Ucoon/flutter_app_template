import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global.dart';
import '../widget/webview_jsbridge.dart';

class JsBridgeController extends GetxController {
  final jsBridge = WebViewJSBridge();

  final RxInt _progressBar = 0.obs;
  get progress => _progressBar.value;
  set progress(value) => _progressBar.value = value;

  void initRegister() {
    registerToken();
    registerDeviceId();
    registerLogout();
  }

  void registerToken() {
    jsBridge.registerHandler("getToken", (data) async {
      debugPrint('getToken');
      String token = Global.getUserToken();
      debugPrint('getToken $token');
      await jsBridge.callHandler('getToken', data: token);
      return token;
    });
  }

  void registerDeviceId() {
    jsBridge.registerHandler("getDeviceId", (data) async {
      debugPrint('getDeviceId');
      String deviceId = Global.getIid();
      debugPrint('deviceId $deviceId');
      await jsBridge.callHandler('getDeviceId', data: deviceId);
      return deviceId;
    });
  }

  void registerLogout() {
    jsBridge.registerHandler("logout", (data) async {
      debugPrint('logout $data');
      Global.logout();
    });
  }
}
