import 'package:get/get.dart';
import '../index.dart';

class GlobalPurchasingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GlobalOrderModel());
    Get.lazyPut(
      () => GlobalPurchasingController(Get.find<GlobalOrderModel>()),
    );
  }
}
