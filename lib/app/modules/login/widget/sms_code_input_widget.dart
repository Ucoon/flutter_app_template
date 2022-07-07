import 'package:tuple/tuple.dart';
import '../../../../widget/buttons.dart';
import '../../../../widget/input.dart';
import '../widget/sms_code_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmsCodeInputWidget extends StatefulWidget {
  final Future<Tuple2<String, String>> Function()? getGraphicCode; //获取图形验证码
  final Future<bool> Function(String phone, String code, String imageId)?
      checkGraphicCode; //验证图形验证码
  final void Function(String phone, String code, String imageId)?
      onSendTap; //获取验证码点击事件
  final Function(String, String)? onSubmit; //提交事件
  final String? buttonText;

  const SmsCodeInputWidget({
    Key? key,
    this.getGraphicCode,
    this.checkGraphicCode,
    this.onSendTap,
    this.onSubmit,
    this.buttonText = 'login',
  }) : super(key: key);

  @override
  _SmsCodeInputWidgetState createState() => _SmsCodeInputWidgetState();
}

class _SmsCodeInputWidgetState extends State<SmsCodeInputWidget> {
  final GlobalKey _formKey = GlobalKey();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  VoidCallback? _onSubmit() {
    String sms = _smsController.text;
    if (sms.isEmpty) {
      return null;
    }
    return () async {
      widget.onSubmit!(_phoneController.text, sms);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
              inputNoBorderWithDividerEdit(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                hintText: 'login_name_hint'.tr,
                isPassword: false,
                marginTop: 0,
                icon: const Icon(
                  Icons.phone_outlined,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                right: 2.w,
                child: SMSCodeTextWidget(
                  _phoneController.text,
                  phoneEditingController: _phoneController,
                  getGraphicCode: widget.getGraphicCode,
                  checkGraphicCode: (phone, code, imageId) async {
                    return true;
                  },
                  onSendTap: (phone, [graphicCode, graphicImageId]) {},
                ),
              ),
            ]),
            inputNoBorderWithDividerEdit(
              controller: _smsController,
              keyboardType: TextInputType.number,
              hintText: 'login_input_sms_hint'.tr,
              marginTop: 0,
              icon: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              onChanged: (sms) {
                setState(() {});
              },
            ),
            SizedBox(
              height: 14.h,
            ),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return PrimaryButton(
      widget.buttonText!.tr,
      _onSubmit(),
    );
  }
}
