import 'package:get/instance_manager.dart';
import '../index.dart';

class PersonalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalMode());
    Get.lazyPut(() => PersonalController(Get.find<PersonalMode>()));
  }
}
