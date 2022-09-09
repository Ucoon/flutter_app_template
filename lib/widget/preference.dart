import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image/image.dart';

class Preference extends StatelessWidget {
  final double verticalPadding;
  final String title;
  final String? subTitle;
  final Color subTitleColor;
  final double subFontSize;
  final bool showArrow;
  final bool required;
  final Widget? trailing;
  final void Function()? onTap;
  final bool trailingExpaned;
  const Preference(
    this.title, {
    Key? key,
    this.subTitle,
    this.subTitleColor = const Color(0XFF828488),
    this.subFontSize = 12,
    this.trailing,
    this.showArrow = true,
    this.required = false,
    this.onTap,
    this.trailingExpaned = false,
    this.verticalPadding = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: verticalPadding.h),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: const Color(0XFF40454F),
                  fontSize: 13.sp,
                ),
              ),
              if (required)
                Text(
                  '*',
                  style: TextStyle(
                    color: const Color(0XFFF14D2F),
                    fontSize: 13.sp,
                  ),
                ),
              // if (!trailingExpaned) const Spacer(),
              if (subTitle != null)
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(left: 4.w),
                        child: Text(
                          subTitle ?? '',
                          style: TextStyle(
                            color: subTitleColor,
                            fontSize: subFontSize.sp,
                          ),
                        ))),
              SizedBox(width: 7.w),
              if (trailing != null) _buildTrailing(),
              if (showArrow) getIconPng('ic_arrow', iconSize: 18.w)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    Widget child = Container(
      margin: EdgeInsets.only(right: 7.w),
      alignment: Alignment.centerRight,
      child: trailing,
    );
    if (trailingExpaned) {
      child = Expanded(child: child);
    }
    return child;
  }
}
