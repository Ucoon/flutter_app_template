import 'package:get/get.dart';
import '../index.dart';

class CustomWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JsBridgeModel());
    Get.lazyPut<JsBridgeController>(
      () {
        return JsBridgeController(Get.find<JsBridgeModel>());
      },
      fenix: true,
    );
  }
}
