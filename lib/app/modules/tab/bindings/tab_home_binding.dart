import 'package:get/get.dart';

import '../index.dart';

class TabHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabHomeController>(
      () => TabHomeController(),
    );
  }
}
