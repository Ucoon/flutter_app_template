import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///无数据提醒小尾巴组件
class NoMoreResult extends StatelessWidget {
  const NoMoreResult({
    Key? key,
    this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Text(
        text ?? 'no_more'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFFCDCDD0),
        ),
      ),
    );
  }
}
