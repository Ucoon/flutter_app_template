import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/widget/widget.dart';
import '/common/utils/utils.dart';

typedef ThirdPartnerLoginCallback = Function(ThirdPlatform thirdPlatform,
    {String? token});

class ThirdPartnerLoginWidget extends StatefulWidget {
  final ThirdPartnerLoginCallback? thirdPartnerLoginCallback;
  const ThirdPartnerLoginWidget({
    Key? key,
    this.thirdPartnerLoginCallback,
  }) : super(key: key);

  @override
  _ThirdPartnerLoginWidgetState createState() =>
      _ThirdPartnerLoginWidgetState();
}

class _ThirdPartnerLoginWidgetState extends State<ThirdPartnerLoginWidget> {
  @override
  void dispose() {
    if (WeChatKit().isRegisteredHandler) {
      WeChatKit().cancelWeChatResponseEventHandler();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 44.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFFFEFEFE),
                      Color(0xFFE0E0E0),
                    ]),
                  ),
                  height: 0.5.h,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  'linear_gradient_or'.tr,
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFFE0E0E0),
                      Color(0xFFFEFEFE),
                    ]),
                  ),
                  height: 0.5.h,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18.w),
          child: IconWithLabelButton(
            'login_by_facebook'.tr,
            leadingIcon: Icon(
              Icons.facebook_outlined,
              size: 18.w,
              color: Colors.lightBlueAccent,
            ),
            onTap: () async {
              String? idToken = await ThirdPlatformLogin().signIdWithFaceBook();
              _callback(ThirdPlatform.facebook, token: idToken);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 18.w, right: 18.w, top: 9.h),
          child: IconWithLabelButton(
            'login_by_apple'.tr,
            leadingIcon: Icon(
              Icons.apple_outlined,
              size: 18.w,
              color: Colors.black,
            ),
            onTap: () async {
              if (Platform.isIOS) {
                toastInfo(msg: '仅限iOS使用');
                return;
              }
              String? idToken = await ThirdPlatformLogin().signIdWithApple();
              _callback(ThirdPlatform.apple, token: idToken);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 18.w, right: 18.w, top: 9.h),
          child: IconWithLabelButton(
            'login_by_wechat'.tr,
            leadingIcon: Icon(
              Icons.wechat_outlined,
              size: 18.w,
              color: Colors.greenAccent,
            ),
            onTap: _loginByWechat,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 18.w, right: 18.w, top: 9.h),
          child: IconWithLabelButton(
            'login_by_google'.tr,
            leadingIcon: Icon(
              Icons.app_settings_alt_sharp,
              size: 18.w,
              color: Colors.yellowAccent,
            ),
            onTap: () async {
              String? idToken = await ThirdPlatformLogin().signInWithGoogle();
              _callback(ThirdPlatform.google, token: idToken);
            },
          ),
        ),
      ],
    );
  }

  void _loginByWechat() async {
    WeChatKit().setWeChatResponseEventHandler((event) {
      debugPrint(
          '_ThirdPartnerLoginWidgetState._loginByWechat state: ${event.state}, code: ${event.code}');
      switch (event.errCode) {
        case WeChatKit.success: //登录成功
          _callback(ThirdPlatform.wechat, token: event.code);
          break;
        default:
          _callback(ThirdPlatform.wechat);
          break;
      }
    });
    await WeChatKit().loginByWeChat();
  }

  void _callback(ThirdPlatform thirdPlatform, {String? token}) {
    widget.thirdPartnerLoginCallback?.call(thirdPlatform, token: token);
  }
}
