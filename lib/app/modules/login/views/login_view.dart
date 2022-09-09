import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiver/strings.dart';
import '../../../../widget/widget.dart';
import '../../../../common/utils/utils.dart';
import '../widget/sms_code_input_widget.dart';
import '../widget/third_partner_login_widget.dart';
import '../index.dart';

class LoginPage extends GetView<LoginController> {
  bool canBack = true;
  LoginPage({Key? key}) : super(key: key) {
    Map<String, dynamic>? arguments = Get.arguments;
    if (arguments != null &&
        arguments.isNotEmpty &&
        arguments.containsKey('canBack')) {
      canBack = arguments['canBack'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusWrapper(
      CommonLayoutPage<LoginController>(
        _buildBody,
        margin: EdgeInsets.zero,
        backgroundColor: Colors.white,
        rootContext: context,
        canBack: canBack,
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget _buildBody(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildTitleWidget(),
        SizedBox(
          height: 55.h,
        ),
        _buildLoginInputWidget(),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 26.h,
        ),
        ThirdPartnerLoginWidget(
          thirdPartnerLoginCallback: (ThirdPlatform platform, value) {
            if (isBlank(value)) {
              toastInfo(msg: '${platform.name}${'login_failed'.tr}');
              return;
            }
          },
        ),
      ],
    );
  }

  Widget _buildLoginInputWidget() {
    return SmsCodeInputWidget(
      checkGraphicCode: (phone, code, imageId) async {
        return true;
      },
      onSendTap: (phone, code, imageId) async {},
      onSubmit: (phone, code) async {
        controller.login();
      },
    );
  }

  Widget _buildTitleWidget() {
    return Container(
      width: ScreenUtil().screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        'login'.tr,
        style: TextStyle(
          color: const Color(0xFF373737),
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
