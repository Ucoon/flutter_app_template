import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../widget/widget.dart';

class AppKit {
  static DateTime? _lastPopTime;

  static Future<bool> exitApplication() {
    if (_lastPopTime == null ||
        DateTime.now().difference(_lastPopTime ?? DateTime.now()) >
            const Duration(seconds: 2)) {
      _lastPopTime = DateTime.now();
      toastInfo(msg: "exit_app".tr);
      return Future.value(false);
    }
    return Future.value(true);
  }

  static void exitApp(BuildContext context) {
    if (Platform.isIOS) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        exit(0);
      }
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
