import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/utils/utils.dart';
import '../common/values/values.dart';
import 'toast.dart';

class CopyButtonWidget extends StatelessWidget {
  final String content;
  final Decoration? decoration;
  final Color? color;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const CopyButtonWidget({
    Key? key,
    required this.content,
    this.color = const Color(0xFF58595B),
    this.decoration,
    this.fontSize = 13,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (content.isEmpty) return;
        await ClipboardKit.setData(content);
        toastInfo(msg: 'copy_success'.tr);
      },
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        alignment: Alignment.center,
        decoration: decoration ??
            BoxDecoration(
              borderRadius: borderRadius3,
              border: Border.all(width: 1.w, color: const Color(0xFF9C9C9C)),
            ),
        child: Text(
          'copy'.tr,
          style: TextStyle(
            color: color,
            fontSize: fontSize.sp,
          ),
        ),
      ),
    );
  }
}
