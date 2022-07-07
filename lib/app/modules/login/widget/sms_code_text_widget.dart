import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiver/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuple/tuple.dart';

import '../../../../widget/widget.dart';

class SMSCodeTextWidget extends StatefulWidget {
  final String phone;
  final Color? color;
  final String? phoneCode;
  final TextEditingController? phoneEditingController;
  final void Function(String, [String?, String?])? onSendTap; //获取验证码点击事件
  final Future<Tuple2<String, String>> Function()? getGraphicCode; //获取图形验证码
  final Future<bool> Function(String, String, String)?
      checkGraphicCode; //验证图形验证码, 验证成功默认发送验证码

  const SMSCodeTextWidget(
    this.phone, {
    Key? key,
    this.getGraphicCode,
    this.checkGraphicCode,
    this.onSendTap,
    this.phoneCode,
    this.phoneEditingController,
    this.color = const Color(0xFF3B86F7),
  }) : super(key: key);

  @override
  _SMSCodeTextWidgetState createState() => _SMSCodeTextWidgetState();
}

class _SMSCodeTextWidgetState extends State<SMSCodeTextWidget> {
  bool isTimeCounting = false;
  Timer? _timer;

  int _countdownTime = 0;

  set countdownTime(value) => _countdownTime = value;

  get countdownTime => _countdownTime;

  @override
  void initState() {
    super.initState();
    if (!isBlank(widget.phone) && widget.getGraphicCode == null) {
      _startCountdownTimer();
    }
  }

  ///验证码倒计时
  _startCountdownTimer() {
    if (countdownTime == 0) {
      _countdownTime = 60;
      const oneSec = Duration(seconds: 1);
      // ignore: prefer_function_declarations_over_variables
      var callback = (timer) => {
            setState(() {
              if (_countdownTime < 1) {
                _timer!.cancel();
              } else {
                _countdownTime = _countdownTime - 1;
              }
            })
          };
      _timer = Timer.periodic(oneSec, callback);
    }
  }

  bool _isTimeCounting() {
    return countdownTime > 0;
  }

  String _timeCountingText() {
    return countdownTime.toString();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String _phone = widget.phone;
        if (_phone.isEmpty && widget.phoneEditingController != null) {
          _phone = widget.phoneEditingController!.text;
        }
        if (_phone.isEmpty) {
          _phone = widget.phoneEditingController!.text;
          toastInfo(msg: 'refund_apply_phone_hint'.tr);
          return;
        }
        _phone = sub(_phone);

        if (_phone.length != 9 && _phone.length != 10) {
          toastInfo(msg: "error_phone".tr);
          return;
        }
        final code = widget.phoneCode ?? '';
        _phone = code + _phone;
        if (widget.getGraphicCode != null) {
          if (countdownTime == 0) {
            _startCountdownTimer();
          }
        }
      },
      child: Text(
        _isTimeCounting()
            ? 'login_no_get_sms'.trArgs([_timeCountingText()])
            : 'login_get_sms'.tr,
        style: TextStyle(
          color: widget.color,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  String sub(String raw) {
    var current = raw;
    if (raw.startsWith('0')) {
      current = raw.replaceFirst('0', '');
    } else if (raw.startsWith('60')) {
      if (raw.length >= 11) {
        current = raw.replaceFirst('60', '');
      }
    }
    return current;
  }
}
