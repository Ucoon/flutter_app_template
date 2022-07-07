import 'package:get/get.dart';
import '../index.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginModel>(() => LoginModel());
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find()),
    );
  }
}
