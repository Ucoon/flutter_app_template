import '../index.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeModel());
    Get.lazyPut(() => HomeController(Get.find<HomeModel>()));
  }
}
