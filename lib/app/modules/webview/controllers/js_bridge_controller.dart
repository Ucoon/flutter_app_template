import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global.dart';
import '../../../base/controller/base_controller.dart';
import 'js_bridge_model.dart';
import '../widget/webview_jsbridge.dart';

class JsBridgeController extends BaseController<JsBridgeModel> {
  final jsBridge = WebViewJSBridge();

  final RxInt _progressBar = 0.obs;

  JsBridgeController(JsBridgeModel model) : super(model);
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
      String deviceId = Global.androidId ?? '';
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
