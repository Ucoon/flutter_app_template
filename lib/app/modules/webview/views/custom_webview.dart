import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/widget/widget.dart';
import '../index.dart';

class CustomWebPage<T extends JsBridgeController> extends GetView<T> {
  CustomWebPage({Key? key}) : super(key: key);
  late String url;
  String? title;
  bool? isCanBack;

  @override
  Widget build(BuildContext context) {
    Map urlMap = Get.arguments;
    url = urlMap["url"] as String;
    if (urlMap.containsKey("title")) {
      title = urlMap["title"] as String;
    }
    if (urlMap.containsKey("isCanBack")) {
      isCanBack = urlMap["isCanBack"] as bool;
    }
    return CommonLayoutPage<JsBridgeController>(
      _buildBody,
      title: title ?? '',
      canBack: isCanBack ?? true,
      onLeaveConfirm: () async {
        if (isCanBack == null) {
          if ((await controller.jsBridge.controller?.canGoBack()) ?? false) {
            controller.jsBridge.controller?.goBack();
            return Future.value(false);
          }
          return Future.value(true);
        } else {
          return Future.value(isCanBack);
        }
      },
      appBarBackgroundColor: Colors.white,
      backgroundColor: const Color(0xFFF8F5F8),
      removeBottom: false,
    );
  }

  Widget _buildBody(BuildContext ctx) {
    return CustomWebWidget(url);
  }
}
