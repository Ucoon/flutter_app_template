import '/app/base/base_model.dart';
import '/app/base/base_model_mixin.dart';

class LoginModel extends BaseModel with BaseModelMixin {
  Future<bool> login() async {
    final resp = await Future.delayed(const Duration(seconds: 3));
    return true;
  }
}
