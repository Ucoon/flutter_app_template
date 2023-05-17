import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppKit {
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
