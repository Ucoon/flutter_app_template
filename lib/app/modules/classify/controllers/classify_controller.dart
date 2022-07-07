import '../../../base/controller/base_controller.dart';
import '../index.dart';

class ClassifyController extends BaseController<ClassifyModel> {
  final classifyState = ClassifyState();

  ClassifyController(ClassifyModel model) : super(model);

  @override
  void onReady() {}
}
