import 'package:get/get.dart';

import '../index.dart';

class CustomWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JsBridgeController>(
          () {
        return JsBridgeController();
      },
      fenix: true,
    );
  }
}
