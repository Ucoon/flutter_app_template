import 'package:get/get.dart';
import '../index.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WelcomeModel>(WelcomeModel());
    Get.put<WelcomeController>(WelcomeController(Get.find<WelcomeModel>()));
  }
}
