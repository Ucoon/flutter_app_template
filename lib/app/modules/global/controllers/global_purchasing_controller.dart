import '../../../base/controller/base_controller.dart';
import '../index.dart';

class GlobalPurchasingController extends BaseController<GlobalOrderModel> {
  final state = GlobalOrderState();

  GlobalPurchasingController(GlobalOrderModel model) : super(model);

  @override
  void onReady() {
    super.onReady();
  }
}
