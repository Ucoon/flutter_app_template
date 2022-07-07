import 'package:get/get.dart';
import '../../../../global.dart';
import '../../../../widget/toast.dart';
import '../../../base/controller/base_controller.dart';
import '../../../routes/app_pages.dart';
import 'login_model.dart';
import 'login_state.dart';

class LoginController extends BaseController<LoginModel> {
  final loginState = LoginState();

  LoginController(LoginModel model) : super(model);

  @override
  void onReady() {
    super.onReady();
  }

  ///登录
  Future<void> login() async {
    return launch(() async {
      Future.delayed(const Duration(milliseconds: 1500), () async {
        toastInfo(msg: 'login_success'.tr);
        await Global.saveUserToken('user_token');
        await Global.saveUserId('user_id');
        await Global.saveIsFirst(true);
        _goToHome();
      });
    }, (err) {
      toastInfo(msg: err.message);
    });
  }

  ///跳转到主界面
  void _goToHome() {
    Get.offAllNamed(Routes.tab);
  }
}
