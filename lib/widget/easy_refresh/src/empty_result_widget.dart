import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../image.dart';

class EmptyResultWidget extends StatelessWidget {
  final String icon;
  final String text;
  final String hint;
  final double iconSize;

  const EmptyResultWidget({
    Key? key,
    required this.icon,
    this.text = '',
    this.hint = '',
    this.iconSize = 208,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getIconPng(
            icon,
            iconSize: iconSize.w,
          ),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF3C424D),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            hint,
            style: TextStyle(
              color: const Color(0xFF828488),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
