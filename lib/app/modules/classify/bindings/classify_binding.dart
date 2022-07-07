import 'package:get/get.dart';
import '../index.dart';

class ClassifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClassifyModel());
    Get.lazyPut(
      () => ClassifyController(Get.find<ClassifyModel>()),
    );
  }
}
