import 'package:get/get.dart';
import '/global.dart';
import '/widget/widget.dart';
import '/app/base/controller/base_controller.dart';
import '/app/routes/app_pages.dart';
import 'login_model.dart';
import 'login_state.dart';

class LoginController extends BaseController<LoginModel> {
  final loginState = LoginState();

  LoginController(LoginModel model) : super(model);


  ///登录
  Future<void> login() async {
    request<bool>(
      model.login(),
      (value) async {
        toastInfo(msg: 'login_success'.tr);
        await Global.saveUserToken('user_token');
        await Global.saveUserId('user_id');
        await Global.saveIsFirst(true);
        _goToHome();
      },
      (err) {
        toastInfo(msg: err.message);
      },
    );
  }

  ///跳转到主界面
  void _goToHome() {
    Get.offAllNamed(Routes.tab);
  }
}
