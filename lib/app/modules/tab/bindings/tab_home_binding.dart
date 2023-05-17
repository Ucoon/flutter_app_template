import 'package:get/get.dart';
import '/app/modules/classify/index.dart';
import '/app/modules/global/index.dart';
import '/app/modules/home/index.dart';
import '/app/modules/personal/index.dart';
import '../index.dart';

class TabHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabHomeController>(
      () => TabHomeController(),
    );
    Get.lazyPut(() => HomeModel());
    Get.lazyPut(() => HomeController(Get.find<HomeModel>()));
    Get.lazyPut(() => GlobalOrderModel());
    Get.lazyPut(() => GlobalPurchasingController(Get.find<GlobalOrderModel>()));
    Get.lazyPut(() => ClassifyModel());
    Get.lazyPut(() => ClassifyController(Get.find<ClassifyModel>()));
    Get.lazyPut(() => PersonalMode());
    Get.lazyPut(() => PersonalController(Get.find<PersonalMode>()));
  }
}
