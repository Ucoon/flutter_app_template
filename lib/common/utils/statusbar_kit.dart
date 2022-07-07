import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///状态栏设置工具类
class StatusBarKit {
  ///设置沉浸式状态栏
  static void setStatusBarDark({bool dark = false, Color? darkColor}) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: dark ? darkColor : Colors.transparent,
          systemNavigationBarIconBrightness:
              dark ? Brightness.light : Brightness.dark,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.light : Brightness.dark,
        ),
      );
    }
  }

  ///设置竖屏
  static Future setPortrait() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }
}
