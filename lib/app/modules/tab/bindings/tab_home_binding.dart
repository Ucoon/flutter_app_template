import 'package:get/get.dart';
import '../../classify/index.dart';
import '../../global/index.dart';
import '../../home/index.dart';
import '../../personal/index.dart';
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
