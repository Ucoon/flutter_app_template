import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiver/strings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'app/routes/app_pages.dart';
import 'common/utils/utils.dart';
import 'common/values/values.dart';

/// 全局静态数据
class Global {
  /// 微信APPID
  static String weChatAppId = "wx5419683abac717df";

  ///微信Universal Links(针对IOS)
  static String universalLink = "https://api.postitchat.com/";

  /// 是否 ioszxs
  static bool isIOS = Platform.isIOS;

  /// android 设备信息
  static late AndroidDeviceInfo androidDeviceInfo;

  /// ios 设备信息
  static late IosDeviceInfo iosDeviceInfo;

  /// 包信息
  static late PackageInfo packageInfo;

  /// 是否第一次打开
  static bool? isFirstOpen;

  /// 是否离线登录
  static bool isOfflineLogin = true;

  /// 是否 release
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  ///全局路由观察者
  static RouteObserver<Route> routeObserver = RouteObserver();

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 读取设备信息
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Global.isIOS) {
      Global.iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    } else {
      Global.androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      WebView.platform = SurfaceAndroidWebView();
    }

    // 包信息
    Global.packageInfo = await PackageInfo.fromPlatform();

    // 本地存储初始化
    await StorageUtil().init();

    //微信sdk初始化
    await WeChatKit().registerWeChatApi(
      weChatAppId,
      universalLink: universalLink,
    );

    var result = await WeChatKit().isWeChatInstalledKit;
    debugPrint("is installed $result");

    // 读取设备第一次打开
    isFirstOpen = StorageUtil().getBool(storageDeviceFirstOpenKey);
    isFirstOpen ??= true;

    var _token = StorageUtil().getJSON(storageTokenKey);
    if (!isBlank(_token)) {
      isOfflineLogin = false;
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    var _locale = LocaleUtil.getAppLocale();
    if (isBlank(_locale)) {
      LocaleUtil.saveAppLocale(const Locale('en', 'US'));
    }
  }

  // 保存用户已打开APP
  static saveAlreadyOpen() {
    StorageUtil().putBool(storageDeviceFirstOpenKey, false);
  }

  // 保存token
  static saveUserToken(String token) async {
    StorageUtil().putJSON(storageTokenKey, token);
    isOfflineLogin = isBlank(token);
  }

  static String getUserToken() {
    return StorageUtil().getJSON(storageTokenKey) ?? '';
  }

  // 保存userId
  static saveUserId(String useId) async {
    StorageUtil().putJSON(storageUserIdKey, useId);
  }

  // 获取userId
  static String getUserId() {
    return StorageUtil().getJSON(storageUserIdKey) ?? '';
  }

  static Future<bool>? saveIsFirst(bool isFirst) {
    return StorageUtil().putBool(storageDeviceFirstLoginKey, isFirst);
  }

  static bool? getIsFirst() {
    return StorageUtil().getBool(storageDeviceFirstLoginKey);
  }

  static saveAgree(bool value) {
    StorageUtil().putBool(storageDeviceAgreeKey, value);
  }

  static bool getAgree() {
    return StorageUtil().getBool(storageDeviceAgreeKey);
  }

  static DateTime? getNotificationDateTime() {
    final data = StorageUtil().getJSON(notificationDateTime);
    return DateTime.tryParse(data.toString());
  }

  static Future<void> setNotificationDateTime(DateTime date) {
    return StorageUtil().putJSON(notificationDateTime, date.toString());
  }

  // 保存设备iid
  static saveIid(String id) async {
    StorageUtil().putJSON(iid, id);
  }

  // 保存设备iid
  static String getIid() {
    return StorageUtil().getJSON(iid) ?? '';
  }

  ///用户退出
  static void logout() {
    saveUserToken('');
    Get.offAllNamed(
      Routes.login('tab'),
      arguments: {'canBack': false},
    );
  }
}
