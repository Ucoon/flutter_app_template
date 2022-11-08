import 'package:flutter/material.dart';
import '/global.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/widget/widget.dart';
import '/common/utils/utils.dart';

class ThirdPartnerLoginWidget extends StatelessWidget {
  final Function? thirdPartnerLoginCallback;
  const ThirdPartnerLoginWidget({
    Key? key,
    this.thirdPartnerLoginCallback,
  }) : super(key: key);

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
              thirdPartnerLoginCallback?.call(ThirdPlatform.facebook, idToken);
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
              if (!Global.isIOS) {
                toastInfo(msg: '仅限iOS使用');
                return;
              }
              String? idToken = await ThirdPlatformLogin().signIdWithApple();
              thirdPartnerLoginCallback?.call(ThirdPlatform.apple, idToken);
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
            onTap: () async {
              await WeChatKit().loginByWeChat();
              thirdPartnerLoginCallback?.call(ThirdPlatform.wechat, '');
            },
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
              thirdPartnerLoginCallback?.call(ThirdPlatform.google, idToken);
            },
          ),
        ),
      ],
    );
  }
}
