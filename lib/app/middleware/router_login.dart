import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global.dart';
import '../routes/app_pages.dart';

/// 第一次欢迎页面
class RouteLoginMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  @override
  int? priority = 0;

  RouteLoginMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    debugPrint('redirect  ${Global.isOfflineLogin} route $route');
    if (Global.isOfflineLogin) {
      if (route?.contains('tab') ?? false) {
        return null;
      }
      _showRegisterDialog();
    } else {
      if (route?.contains('setting') ?? false) {
        return null;
      }
    }
    return const RouteSettings(name: Routes.tab);
  }

  _showRegisterDialog() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!Get.currentRoute.contains(Routes.login(''))) {
        ///todo 隐私弹窗
      }
    });
  }
}
