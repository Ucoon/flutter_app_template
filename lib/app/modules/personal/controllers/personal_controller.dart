import '../index.dart';
import '/app/base/controller/base_controller.dart';

class PersonalController extends BaseController<PersonalMode> {
  PersonalController(PersonalMode model) : super(model);
  final PersonalState state = PersonalState();
}
